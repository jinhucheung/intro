module Intro
  module Admin
    class ApplicationController < ::Intro::ApplicationController

      protected

      def authenticate
        redirect_to unauthenticated_path unless authenticated?
      end

      def authenticated?
        session[:intro_admin_authenticated] ||
        Intro.config.admin_username == params[:username] &&
        Intro.config.admin_password == params[:password]
      end

      alias_method :unauthenticated_path, :new_admin_session_path
    end
  end
end