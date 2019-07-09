module Intro
  module Admin
    class ToursController < ::Intro::Admin::ApplicationController
      if Rails::VERSION::MAJOR > 3
        before_action :authenticate
      else
        before_filter :authenticate
      end

      def index
        @tours = Intro::Tour.recent.page(params[:page]).per(15)
      end

      def new
        @tour = Intro::Tour.new
      end

      def post; end
    end
  end
end