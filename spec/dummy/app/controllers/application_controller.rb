class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return unless has_signed_in?

    @current_user ||= User.first_or_create
  end

  def has_signed_in?
    session[:intro_admin_authenticated] == Intro.config.admin_username_digest
  end
end
