module Intro
  module Generators
    class AssetsGenerator < Rails::Generators::Base
      desc 'Add intro assets files'
      source_root File.expand_path('../../../..', __FILE__)

      def add_shepherd_stylesheets
        copy_file 'app/javascript/stylesheets/intro/shepherd/_variables.scss', 'app/javascript/stylesheets/intro/_variables.scss'
        copy_file 'app/javascript/stylesheets/intro/shepherd/base.scss', 'app/javascript/stylesheets/intro/custom.scss'
      end

      def add_shepherd_packs
        create_file 'app/javascript/packs/intro/custom.js', 'import "stylesheets/intro/custom"'
      end
    end
  end
end