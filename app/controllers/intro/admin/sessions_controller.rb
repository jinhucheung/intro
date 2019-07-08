module Intro
  module Admin
    class SessionsController < ::Intro::Admin::ApplicationController
      if Rails::VERSION::MAJOR > 3
        before_action :unauthenticate, only: :new
        before_action :authenticate, only: :sign_out
      else
        before_filter :unauthenticate, only: :new
        before_filter :authenticate, only: :sign_out
      end

      def new; end

      def create
        if authenticated?
          session[:intro_admin_authenticated] = Intro.config.admin_username_digest
          redirect_to admin_tours_path
        else
          flash.now.alert = t('intro.errors.sign_in')
          render :new
        end
      end

      def sign_out
        session.delete(:intro_admin_authenticated)
        redirect_to unauthenticated_path
      end

      protected

      def unauthenticate
        redirect_to admin_tours_path if authenticated?
      end
    end
  end
end