require 'uri'

module Intro
  class ToursController < ::Intro::ApplicationController
    if Rails::VERSION::MAJOR > 3
      before_action :authenticate
      before_action :require_tour, only: :record
    else
      before_filter :authenticate
      before_filter :require_tour, only: :record
    end

    def index
      tours = Intro::Tour.with_controller_and_action(params[:controller_path], params[:action_name])
      tours = tours.published

      tours = filter_tours_by_route(tours)
      tours = filter_tours_by_histories(tours)
      tours = filter_tours_by_expired_time(tours)

      render json: { data: tours.map(&:expose_attributes) }
    end

    def record
      history = Intro::TourHistory.with_user_and_tour(current_user, @tour).first_or_initialize
      history.increment!(:touch_count)
      render json: { message: t('intro.admin.update_success') }
    end

    protected

    def authenticate
      render json: { message: t('intro.errors.unauthorized') }, status: :unauthorized unless current_user
    end

    def require_tour
      @tour = Intro::Tour.find_by_id(params[:id]) if params[:id].present?
      render json: { message: t('intro.errors.tour_not_found') }, status: :not_found unless @tour
    end

    def filter_tours_by_route(tours)
      uri = URI(params[:original_url]) rescue nil if params[:original_url].present?
      return tours if uri.blank?

      # filter tours by simple route in strict
      strict_selector = lambda do |tour|
        simple = URI(tour.simple_route) rescue nil if tour.simple_route.present?
        return false if simple.blank?

        (simple.host.blank? || simple.host == uri.host) && simple.path == uri.path && simple.query == uri.query
      end

      # filter tours by path paramss
      path_route = Intro::Tour.extract_route(uri.to_s)
      path_selector = lambda do |tour|
        return true if path_route.blank?

        path_route[:source][:action] == tour.action_name &&
        path_route[:source][:controller] == tour.controller_path &&
        (tour.route[:source].blank? || path_route[:source].except(:controller, :action).keys == tour.route[:source].except(:controller, :action).keys)
      end

      # filter tours by query string
      request_query = Rack::Utils.parse_nested_query(uri.query)
      query_selector = lambda do |tour|
        return true if tour.route[:query].blank?

        tour_query = Rack::Utils.parse_nested_query(tour.route[:query])
        (request_query.to_a & tour_query.to_a).any?
      end

      tours.select do |tour|
        if tour.strict_route?
          strict_selector.call(tour)
        else
          path_selector.call(tour) && query_selector.call(tour)
        end
      end
    end

    def filter_tours_by_histories(tours)
      tour_ids = Intro::TourHistory.with_user_and_tour(current_user, tours.map(&:id)).ge_max_touch.pluck(:tour_id)
      tours.select {|tour| tour_ids.exclude?(tour.id)}
    end

    def filter_tours_by_expired_time(tours)
      tours.reject(&:expired?)
    end
  end
end