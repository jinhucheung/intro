module Intro
  class Tour < ActiveRecord::Base
    serialize :route, Hash
    serialize :options, Hash

    attr_accessible :ident, :controller_path, :action_name, :options, :route, :published, :expired_at if Rails::VERSION::MAJOR < 4

    has_many :tour_histories, class_name: 'Intro::TourHistory', dependent: :destroy

    validates :ident, presence: true, uniqueness: true

    scope :with_controller_and_action, ->(controller, action) { where(controller_path: controller, action_name: action) }
    scope :published, -> { where(published: true) }
    scope :recent, -> { order(created_at: :desc) }

    before_save :format_attributes
    before_save :update_route
    after_commit :clear_cache if Intro.config.cache

    def expose_attributes
      as_json(only: %i[id ident controller_path action_name options]).with_indifferent_access
    end

    def simple_route
      route[:simple] rescue nil
    end

    def simple_route_changed?
      return false unless route_changed?

      simple_route != route_was[:simple] rescue false
    end

    def strict_route?
      route[:strict] rescue false
    end

    def expired?
      !!expired_at && expired_at < Time.now
    end

    class << self
      def extract_route(url)
        url = "/#{url}" if url !~ /^((https?:\/\/)|(\/))/i
        uri = URI(url)

        {
          source: recognize_path(uri.path),
          query: uri.query
        }
      rescue
        {}
      end

      protected

      # Seek route info in main app and engines
      # @thanks https://gist.github.com/jtanium/6114632
      def recognize_path(path, options = {})
        Rails.application.routes.recognize_path(path, options)
      rescue ActionController::RoutingError
        Rails::Engine.subclasses.detect do |engine|
          engine_path   = engine.routes._generate_prefix({}) if engine.routes.respond_to?(:_generate_prefix)
          engine_path ||= engine.routes.find_script_name({}) if engine.routes.respond_to?(:find_script_name)
          next unless engine_path

          path_for_engine = path.gsub(%r(^#{engine_path}), '')
          recognized_path = engine.routes.recognize_path(path_for_engine, options) rescue nil
          break recognized_path if recognized_path
        end
      end
    end

    def format_attributes
      %i[ident controller_path action_name].each do |attribute|
        strip_attribute = send(attribute).try(:strip)
        send("#{attribute}=", strip_attribute)
      end

      self.options = JSON.parse(options) rescue {} unless options.is_a?(Hash)
      self.route   = JSON.parse(route) rescue {} unless route.is_a?(Hash)
    end

    def update_route
      if simple_route.present? && simple_route_changed?
        route = self.class.extract_route(simple_route)
        source = route[:source] || {}

        self.controller_path = source[:controller].to_s if self.controller_path.blank?
        self.action_name = source[:action].to_s if self.action_name.blank?
        self.route.reverse_merge!(route)
      end

      self.route[:strict] = %w[1 true].include?(self.route[:strict].to_s)
      self.route
    end

    def clear_cache
      if destroyed? || (previous_changes.keys & %w[controller_path action_name published]).any?
        Intro.cache.delete(controller_path, action_name)
      end
    end
  end
end
