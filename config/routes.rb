Intro::Engine.routes.draw do
  namespace :admin do
    resources :sessions, only: [:new, :create] do
      delete :sign_out, on: :collection
    end

    resources :tours

    root to: 'tours#index'
  end
end