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

    # admin account for accessing backstage
    attr_accessor :admin_username, :admin_password

    # admin_authenticate_account will override authenticate_account process for backstage, it should return boolean
    attr_accessor :admin_authenticate_account

    # redirect to unauthenticated_admin_path if user is failed to authenticated, default: '/intro/admin/sessions/new'
    attr_accessor :unauthenticated_admin_path

    # the path for sign out an admin, default: '/intro/admin/sign_out'
    attr_accessor :sign_out_admin_path

    # the storage of carrierwave, default: :file
    attr_accessor :carrierwave_storage

    # cache tours status to reduce requests, default: false
    # use `Rails.cache` to store tours status, change `config.cache_store` for different strategies
    attr_accessor :cache

    # display tour without signing in, default: false
    attr_accessor :visible_without_signing_in

    def initialize
      @enable = true

      @user_class = 'User'

      @current_user_method = 'current_user'

      @max_touch_count = 1

      @carrierwave_storage = :file
    end

    def admin_username_digest
      @admin_username_digest ||= Digest::SHA1.hexdigest(admin_username.to_s)
    end
  end
end