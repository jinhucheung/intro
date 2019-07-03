require 'rails/generators/migration'
require 'rails/generators/active_record'

module Intro
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ::Rails::Generators::Migration

      desc 'Install Intro base files'
      source_root File.expand_path('../templates', __FILE__)

      def add_intro_initializer
        template 'config/initializers/intro.rb'
      end

      def add_intro_tours_migration
        migration_template 'db/create_intro_tours.rb.erb',
                           'db/migrate/create_intro_tours.rb',
                           migration_version: migration_version
      end

      def add_intro_tour_histories_migration
        migration_template 'db/create_intro_tour_histories.rb.erb',
                           'db/migrate/create_intro_tour_histories.rb',
                           migration_version: migration_version
      end

      private

      def self.next_migration_number(dirname)
        ::ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if Rails::VERSION::MAJOR >= 5
      end
    end
  end
end
