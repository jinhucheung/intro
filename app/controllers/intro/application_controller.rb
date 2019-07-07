module Intro
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    helper_method :intro_translate

    protected

    def intro_translate(key, options = {})
      I18n.t(key, options.merge(scope: :intro))
    end
  end
end
