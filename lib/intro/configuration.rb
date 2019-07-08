require 'digest/sha1'

module Intro
  class Configuration
    # switch intro status. all tours don't display if intro is disable. default: true
    attr_accessor :enable

    # class name of your User Modal, default: 'User'
    attr_accessor :user_class

    # current_user method name in your controller, default: 'current_user'
    attr_accessor :current_user_method

    # after user touches a tour more than max count, the tour doesn't display. default: 1
    attr_accessor :max_touch_count

    # admin account for accessing background web
    attr_accessor :admin_username, :admin_password

    # admin_authenticate_account will override authenticate_account process for background web, it should return boolean
    attr_accessor :admin_authenticate_account

    # redirect to unauthenticated_admin_path if user is failed to authenticated, default: '/intro/admin/sessions/new'
    attr_accessor :unauthenticated_admin_path

    # the path for sign out an admin, default: '/intro/admin/sign_out'
    attr_accessor :sign_out_admin_path

    def initialize
      @enable = true

      @user_class = 'User'

      @current_user_method = 'current_user'

      @max_touch_count = 1
    end

    def admin_username_digest
      @admin_username_digest ||= Digest::SHA1.hexdigest(admin_username.to_s)
    end
  end
end