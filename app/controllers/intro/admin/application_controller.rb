module Intro
  module Admin
    class ApplicationController < ::Intro::ApplicationController

      protected

      def authenticate
        redirect_to unauthenticated_path unless authenticated?
      end

      def authenticated?
        return @_authenticated if defined?(@_authenticated)

        @_authenticated = has_signed_in? || authenticate_account
      end

      def has_signed_in?
        session[:intro_admin_authenticated] == Intro.config.admin_username_digest
      end

      def authenticate_account
        if Intro.config.admin_authenticate_account.respond_to?(:call)
          instance_exec(&Intro.config.admin_authenticate_account)
        else
          Intro.config.admin_username == params[:username] &&
          Intro.config.admin_password == params[:password]
        end
      end

      def unauthenticated_path
        Intro.config.unauthenticated_admin_path.presence || new_admin_session_path
      end
    end
  end
end