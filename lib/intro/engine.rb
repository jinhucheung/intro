module Intro
  class Engine < ::Rails::Engine
    isolate_namespace Intro

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
