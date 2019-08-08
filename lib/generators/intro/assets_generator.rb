module Intro
  module Generators
    class AssetsGenerator < Rails::Generators::Base
      desc 'Add intro assets files'
      source_root File.expand_path('../../../..', __FILE__)

      def add_shepherd_stylesheets
        directory 'app/assets/stylesheets/intro/shepherd'
      end
    end
  end
end