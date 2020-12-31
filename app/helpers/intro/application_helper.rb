module Intro
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      Intro.webpacker
    end

    def sign_out_admin_intro_path
      Intro.config.sign_out_admin_path.presence || sign_out_admin_sessions_path
    end
  end
end
