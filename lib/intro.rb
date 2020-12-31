require 'webpacker'
require 'carrierwave'
require 'kaminari'

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

    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: Intro::Engine.root,
        config_path: Intro::Engine.root.join('config', 'webpacker.yml')
      )
    end
  end
end