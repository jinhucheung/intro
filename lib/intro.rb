require 'shepherdjs_rails'
require 'carrierwave'
require 'kaminari'
require 'rails-ujs'

require 'intro/engine'
require 'intro/cache'
require 'intro/configuration'
require 'intro/helpers/view_helper'

module Intro
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure(&block)
      config.instance_exec(&block)
    end

    def cache
      Intro::Cache
    end
  end
end