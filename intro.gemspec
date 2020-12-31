$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "intro/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "intro"
  s.version     = Intro::VERSION
  s.authors     = ["Jim Cheung"]
  s.email       = ["hi.jinhu.zhang@gmail.com"]
  s.homepage    = "https://github.com/jinhucheung/intro"
  s.summary     = "Intro brings your rails application to new feature introduction and step-by-step users guide"
  s.license     = "MIT"

  s.files = Dir["{bin,app,config,db,lib}/**/*", "package.json", "postcss.config.js", "public/.keep", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 6.0"
  s.add_dependency "carrierwave"
  s.add_dependency "kaminari", ">= 0.17.0"
  s.add_dependency "webpacker"

  s.add_development_dependency "sqlite3", "1.4"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "rails-controller-testing"
  s.add_development_dependency "byebug"
end
