module Intro
  class ToursController < ::Intro::ApplicationController
    def index
      tours = Intro::Tour.with_controller_and_action(params[:controller_path], params[:action_name])
      tours = tours.published

      render json: { data: tours.map(&:expose_attributes) }
    end

    def record; end
  end
end