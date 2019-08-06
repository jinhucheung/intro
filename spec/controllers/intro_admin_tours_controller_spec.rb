require 'rails_helper'

describe Intro::Admin::ToursController, type: :controller do
  routes { Intro::Engine.routes }

  let(:tour) { create(:intro_tour) }

  context 'unauthorized' do
    it 'should redirect to unauthenticated_path' do
      get :index
      expect(response).to redirect_to unauthenticated_path

      get :new
      expect(response).to redirect_to unauthenticated_path

      post :create
      expect(response).to redirect_to unauthenticated_path

      get :route, format: :json
      expect(response).to have_http_status(:unauthorized)

      post :attempt
      expect(response).to redirect_to unauthenticated_path

      get :show, id: 0
      expect(response).to redirect_to unauthenticated_path

      get :edit, id: 0
      expect(response).to redirect_to unauthenticated_path

      put :update, id: 0
      expect(response).to redirect_to unauthenticated_path

      delete :destroy, id: 0
      expect(response).to redirect_to unauthenticated_path

      put :publish, id: 0
      expect(response).to redirect_to unauthenticated_path
    end

    it 'should redirect to custom unauthenticated_admin_path' do
      revert_intro_config do
        Intro.config.unauthenticated_admin_path = '/login'
        get :index
        expect(response).to redirect_to '/login'
      end
    end
  end

  context 'authorized' do
    before do
      session[:intro_admin_authenticated] = Intro.config.admin_username_digest
    end

    after do
      session.delete(:intro_admin_authenticated)
    end

    context '#index' do
      it 'should render index template' do
        get :index
        expect(response).to be_success
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:success)
      end

      it 'should assigns @tours' do
        get :index
        expect(assigns(:tours)).not_to be_nil
        expect(assigns(:tours)).to respond_to(:total_pages)
      end
    end

    context '#new' do
      it 'should render new template' do
        get :new
        expect(response).to be_success
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:success)
      end

      it 'should assigns @tour' do
        get :new
        expect(assigns(:tour)).not_to be_nil
        expect(assigns(:tour).new_record?).to be true
      end
    end

    context '#create' do
      it 'should create tour with ident successfully' do
        expect { post :create, tour: { ident: random_string } }.to change { Intro::Tour.count }.by(1)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to admin_tour_path(assigns(:tour))
      end

      it 'failed to create tour without ident' do
        expect { post :create, tour: {} }.to change { Intro::Tour.count }.by(0)
        expect(assigns(:tour)).not_to be_nil
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:success)
      end
    end

    context '#route' do
      it 'should get route with path' do
        get :route, path: '/intro/admin/tours?xyz=1', format: :json

        expect(response).to have_http_status(:success)
        expect(response.body).not_to be_nil
        expect(json_body[:data]).not_to be_nil
        expect(json_body[:data][:source]).not_to be_nil
        expect(json_body[:data][:source][:controller]).to eq 'intro/admin/tours'
        expect(json_body[:data][:source][:action]).to eq 'index'
        expect(json_body[:data][:query]).to eq 'xyz=1'
      end
    end

    context '#attempt' do
      it 'should get tour options with options' do
        post :attempt, tour: { options: { title: 'title', content: 'content' } }, format: :json

        expect(response).to have_http_status(:success)
        expect(json_body[:data]).not_to be_nil
        expect(json_body[:data][:options]).not_to be_empty
        expect(json_body[:data][:options][:title]).to eq 'title'
        expect(json_body[:data][:options][:content]).to eq 'content'
      end

      it 'should not get tour options without options' do
        post :attempt, tour: {}, format: :json

        expect(response).to have_http_status(:success)
        expect(json_body[:data]).not_to be_nil
        expect(json_body[:data][:options]).to be_empty
      end
    end

    context 'without tour' do
      it 'should get not found' do
        get :show, id: 0
        expect(response).to redirect_to admin_tours_path

        get :show, id: 0, format: :json
        expect(response).to have_http_status(:not_found)

        get :edit, id: 0
        expect(response).to redirect_to admin_tours_path

        put :update, id: 0
        expect(response).to redirect_to admin_tours_path

        delete :destroy, id: 0
        expect(response).to redirect_to admin_tours_path

        put :publish, id: 0
        expect(response).to redirect_to admin_tours_path
      end
    end

    context 'with tour' do
      context '#show' do
        it 'should render edit template' do
          get :show, id: tour.id
          expect(assigns(:tour)).not_to be_nil
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:success)
        end
      end

      context '#edit' do
        it 'should render edit template' do
          get :show, id: tour.id
          expect(assigns(:tour)).not_to be_nil
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:success)
        end
      end

      context '#update' do
        it 'should render edit template' do
          put :update, id: tour.id, tour: { ident: "new-#{tour.ident}" }
          expect(assigns(:tour)).not_to be_nil
          expect(response).to render_template(:edit)
        end

        it 'should update tour with valid ident successfully' do
          new_ident = "new-#{tour.ident}"
          put :update, id: tour.id, tour: { ident: new_ident }
          expect(assigns(:tour).previous_changes).to have_key('ident')
          expect(assigns(:tour).ident).to eq new_ident
        end

        it 'should update tour with valid controller successfully' do
          new_controller = "new-#{tour.controller_path}"
          put :update, id: tour.id, tour: { controller_path: new_controller }
          expect(assigns(:tour).previous_changes).to have_key('controller_path')
          expect(assigns(:tour).controller_path).to eq new_controller
        end

        it 'should update tour with valid action successfully' do
          new_action = "new-#{tour.action_name}"
          put :update, id: tour.id, tour: { action_name: new_action }
          expect(assigns(:tour).previous_changes).to have_key('action_name')
          expect(assigns(:tour).action_name).to eq new_action
        end

        it 'should update tour with valid options successfully' do
          options = { title: 'title' }
          put :update, id: tour.id, tour: { options: options }
          expect(assigns(:tour).previous_changes).to have_key('options')
          expect(assigns(:tour).options).not_to be_nil
          expect(assigns(:tour).options['title']).to eq 'title'
        end

        it 'should update tour with valid route successfully' do
          route = { simple: '/' }
          put :update, id: tour.id, tour: { route: route }
          expect(assigns(:tour).previous_changes).to have_key('route')
          expect(assigns(:tour).route).not_to be_nil
          expect(assigns(:tour).route['simple']).to eq '/'
        end

        it 'should update tour with valid expired time successfully' do
          new_expired_at = 1.day.since.strftime('%F')
          put :update, id: tour.id, tour: { expired_at: new_expired_at }
          expect(assigns(:tour).previous_changes).to have_key('expired_at')
          expect(assigns(:tour).expired_at.strftime('%F')).to eq new_expired_at
        end
      end

      context '#destroy' do
        it 'should destroy tour successfully' do
          delete :destroy, id: tour.id
          expect(assigns(:tour).destroyed?).to be true
          expect(response).to redirect_to admin_tours_path
        end
      end

      context '#publish' do
        it 'should get published tour with active params' do
          put :publish, id: tour.id, published: 'true'
          expect(assigns(:tour).published).to be true
        end

        it 'should get unpublished tour with inactive params' do
          put :publish, id: tour.id, published: 'false'
          expect(assigns(:tour).published).to be false
        end
      end
    end
  end
end