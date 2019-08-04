Intro::Engine.routes.draw do
  namespace :admin do
    resources :sessions, only: [:new, :create] do
      delete :sign_out, on: :collection
    end

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
end