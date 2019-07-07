module Intro
  module Admin
    class ApplicationController < ::Intro::ApplicationController

      protected

      def authenticate
        redirect_to unauthenticated_path unless authenticated?
      end

      def authenticated?
        return @_authenticated if defined?(@_authenticated)

        @_authenticated =
          if Intro.config.admin_authenticated.respond_to?(:call)
            instance_exec(&Intro.config.admin_authenticated)
          else
            session[:intro_admin_authenticated] ||
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