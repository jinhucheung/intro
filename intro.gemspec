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

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "carrierwave"
  s.add_dependency "kaminari", ">= 0.17.0"
  s.add_dependency "sprockets"
  s.add_dependency "shepherdjs_rails", "5.0.1"
  s.add_dependency "jquery-rails"
  s.add_dependency "sass-rails", "6.0.0"

  s.add_development_dependency "sqlite3", "1.3.13"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "byebug"
end
