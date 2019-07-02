module Intro
  class Configuration
    attr_accessor :current_user_method

    def initialize
      @current_user_method = 'current_user'

      super
    end
  end
end