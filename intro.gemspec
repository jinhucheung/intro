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
  s.summary     = "new feature introduction and step-by-step users guide for your rails application"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2"

  s.add_development_dependency "sqlite3"
end
