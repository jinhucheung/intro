module Intro
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception

    helper_method :current_user

    alias_method :origin_current_user, Intro.config.current_user_method.to_sym

    def current_user
      origin_current_user
    end
  end
end
