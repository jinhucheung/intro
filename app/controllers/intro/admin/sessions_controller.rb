module Intro
  module Admin
    class SessionsController < ::Intro::Admin::ApplicationController
      if Rails::VERSION::MAJOR > 3
        before_action :unauthenticate, only: :new
      else
        before_filter :unauthenticate, only: :new
      end

      def new; end

      def create
        if authenticated?
          session[:intro_admin_authenticated] = Intro.config.admin_username_digest
          redirect_to admin_tours_path
        else
          flash.now.alert = intro_translate('error.sign_in')
          render :new
        end
      end

      protected

      def unauthenticate
        redirect_to admin_tours_path if authenticated?
      end
    end
  end
end