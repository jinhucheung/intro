FactoryBot.define do
  factory :intro_tour, class: 'Intro::Tour' do
    ident { "tour-#{Time.now.to_i}-#{(0..9).to_a.sample(6).join}" }
  end
end
