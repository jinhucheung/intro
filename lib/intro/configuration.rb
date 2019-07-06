module Intro
  class Configuration
    # class name of your User Modal, default: 'User'
    attr_accessor :user_class

    # current_user method name in your controller, default: 'current_user'
    attr_accessor :current_user_method

    # after user touches a tour more than max count, the tour doesn't display. default: 1
    attr_accessor :max_touch_count

    def initialize
      @user_class = 'User'

      @current_user_method = 'current_user'

      @max_touch_count = 1
    end
  end
end