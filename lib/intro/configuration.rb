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

    def initialize
      @enable = true

      @user_class = 'User'

      @current_user_method = 'current_user'

      @max_touch_count = 1
    end
  end
end