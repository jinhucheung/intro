require 'intro/engine'
require 'intro/configuration'

module Intro
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure(&block)
      config.instance_exec(&block)
    end
  end
end