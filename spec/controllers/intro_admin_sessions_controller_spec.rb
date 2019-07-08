require 'rails_helper'

describe Intro::Admin::SessionsController, type: :controller do
  routes { Intro::Engine.routes }

  context '#new' do
    it 'should has same action' do
      get :new
      expect(response).to be_success
    end

    it 'should render same template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  context '#create' do
    it 'should be authenticated with valid intro admin account' do
      post :create, { username: Intro.config.admin_username, password: Intro.config.admin_password }

      expect(flash[:alert]).to be_nil
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to admin_tours_path
    end

    it 'should be unauthenticated with invalid admin username or password' do
      post :create, { username: 'test_user', password: Intro.config.admin_password }

      expect(flash[:alert]).not_to be_empty
      expect(response).to render_template(:new)

      post :create, { username: Intro.config.admin_username, password: 'qwe123' }

      expect(flash[:alert]).not_to be_empty
      expect(response).to render_template(:new)
    end

    it 'should be authenticated with valid account by admin_authenticate_account' do
      revert_intro_config do
        Intro.config.admin_authenticate_account = -> { params[:username] == 'root' && params[:password] == 'qwe123' }

        post :create, { username: 'root', password: 'qwe123' }

        expect(flash[:alert]).to be_nil
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to admin_tours_path
      end
    end

    it 'should be unauthenticated with invalid account by admin_authenticate_account' do
      revert_intro_config do
        Intro.config.admin_authenticate_account = -> { params[:username] == 'root' && params[:password] == 'qwe123' }

        post :create, { username: 'test', password: 'test123' }

        expect(flash[:alert]).not_to be_empty
        expect(response).to render_template(:new)
      end
    end
  end

  context '#sign_out' do
    it 'should clear session for signed user' do
      post :create, { username: Intro.config.admin_username, password: Intro.config.admin_password }
      expect(session[:intro_admin_authenticated]).not_to be_nil

      delete :sign_out
      expect(session[:intro_admin_authenticated]).to be_nil
    end
  end
end