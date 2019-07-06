FactoryBot.define do
  factory :intro_tour_history, class: 'Intro::TourHistory' do
    association :user
    association :tour, factory: :intro_tour
  end
end
