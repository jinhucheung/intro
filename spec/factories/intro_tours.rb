FactoryBot.define do
  factory :intro_tour, class: 'Intro::Tour' do
    ident { "tour-#{Time.now.to_i}" }
  end
end
