module Intro
  module ApplicationHelper
    def sign_out_admin_intro_path
      Intro.config.sign_out_admin_path.presence || sign_out_admin_sessions_path
    end
  end
end
