module Intro
  module Admin
    class ToursController < ::Intro::Admin::ApplicationController
      if Rails::VERSION::MAJOR > 3
        before_action :authenticate
      else
        before_filter :authenticate
      end

      def index; end
    end
  end
end