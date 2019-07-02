module Intro
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Install Intro base files'
      source_root File.expand_path('../templates', __FILE__)

      def add_intro_initializer
        template 'config/initializers/intro.rb'
      end
    end
  end
end
