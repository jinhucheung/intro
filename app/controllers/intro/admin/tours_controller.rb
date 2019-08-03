module Intro
  module Admin
    class ToursController < ::Intro::Admin::ApplicationController
      if Rails::VERSION::MAJOR > 3
        before_action :authenticate
        before_action :require_tour, except: [:index, :new, :create]
      else
        before_filter :authenticate
        before_filter :require_tour, except: [:index, :new, :create]
      end

      def index
        @tours = Intro::Tour.recent.page(params[:page]).per(15)
      end

      def new
        @tour = Intro::Tour.new
      end

      def create
        @tour = Intro::Tour.new(tour_params)

        if @tour.save
          redirect_to admin_tour_path(@tour), notice: t('intro.admin.add_success')
        else
          render :new
        end
      end

      def show
        render :edit
      end

      def edit; end

      def update
        flash.now[:notice] = t('intro.admin.update_success') if @tour.update_attributes(tour_params)
        render :edit
      end

      def publish; end

      protected

      def tour_params
        _params = params[:tour].slice(:ident, :controller_path, :action_name, :options, :route, :expired_at)
        _params.permit! if Rails::VERSION::MAJOR > 3
        _params
      rescue
        {}
      end

      def require_tour
        @tour = Intro::Tour.find_by_id(params[:id])

        @tour || respond_to do |format|
          format.html { redirct_to admin_tours_path, alert: t('intro.admin.tips.tour_not_found'), status: :not_found }
          format.any  { head :not_found  }
        end
      end
    end
  end
end