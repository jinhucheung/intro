module Intro
  class TourHistory < ActiveRecord::Base
    attr_accessible :tour_id, :user_id, :touch_count if Rails::VERSION::MAJOR < 4

    belongs_to :tour, class_name: 'Intro::Tour'
    belongs_to :user, class_name: Intro.config.user_class.classify

    validates :tour, :user, presence: true

    scope :with_user_and_tour, ->(user, tour) { where(user_id: user, tour_id: tour) }
    scope :ge_max_touch, -> { where('touch_count >= ?', Intro.config.max_touch_count) }
  end
end

Intro.config.user_class.classify.constantize.has_many :intro_tour_histories,
                                                      class_name: 'Intro::TourHistory',
                                                      dependent: :destroy