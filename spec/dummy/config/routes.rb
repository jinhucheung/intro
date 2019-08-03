Rails.application.routes.draw do

  mount Intro::Engine => "/intro"

  root to: 'home#index'
end
