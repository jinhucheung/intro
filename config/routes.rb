Intro::Engine.routes.draw do
  namespace :admin do
    resources :sessions, only: [:new, :create]

    resources :tours, only: [:index]

    root to: 'tours#index'
  end
end