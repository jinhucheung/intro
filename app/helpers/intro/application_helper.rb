module Intro
  module ApplicationHelper
    def sign_out_admin_intro_path
      Intro.config.sign_out_admin_path.presence || sign_out_admin_sessions_path
    end

    def intro_tag
      return unless enable_intro?

      <<-HTML
        #{javascript_include_tag('intro/application')}
        #{stylesheet_link_tag('intro/application')}
      HTML
    end

    def enable_intro?
      Intro.config.enable && request.get? && !request.xhr? && public_send(Intro.config.current_user_method)
    end
  end
end
