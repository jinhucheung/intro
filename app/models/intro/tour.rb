module Intro
  class Tour < ActiveRecord::Base
    serialize :route, Hash
    serialize :options, Hash

    attr_accessible :ident, :controller_path, :action_name, :options, :route, :posted, :expired_at if Rails::VERSION::MAJOR < 4

    has_many :tour_histories, class_name: 'Intro::TourHistory', dependent: :destroy

    validates :ident, presence: true, uniqueness: true

    scope :with_controller_and_action, ->(controller, action) { where(controller_path: controller, action_name: action) }
    scope :recent, -> { order(created_at: :desc) }

    before_save :format_attributes
    before_save :format_options

    def expose_attributes
      as_json(only: %i[id ident controller_path action_name options])
    end

    def simple_route
      route.is_a?(Hash) && route[:simple]
    end

    def expired?
      expired_at && expired_at < Time.now
    end

    protected

    def format_attributes
      %i[ident controller_path action_name].each do |attribute|
        strip_attribute = send(attribute).try(:strip)
        send("#{attribute}=", strip_attribute)
      end
    end

    def format_options
      self.options = JSON.parse(options) rescue {} unless options.is_a?(Hash)
      keys = (self.options.keys - %w[tooltip steps]).push(self.options['type'])
      self.options = self.options.slice(*keys)
    end
  end
end
