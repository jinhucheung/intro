Intro::Engine.routes.draw do
  namespace :admin do
    resources :sessions, only: [:new, :create] do
      delete :sign_out, on: :collection
    end

    resources :images, only: [:create]

    resources :tours do
      member do
        put :publish
      end

      collection do
        get  :route
        post :attempt
      end
    end

    root to: 'tours#index'
  end

  resources :tours, only: [:index] do
    post :record, on: :collection
  end
end