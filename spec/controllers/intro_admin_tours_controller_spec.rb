require 'rails_helper'

describe Intro::Admin::ToursController, type: :controller do
  routes { Intro::Engine.routes }

  context '#index' do
    it 'should be redirect to unauthenticated_path if account is unauthenticated' do
      revert_intro_config do
        get :index
        expect(response).to redirect_to new_admin_session_path

        Intro.config.unauthenticated_admin_path = '/login'
        get :index
        expect(response).to redirect_to '/login'
      end
    end
  end
end