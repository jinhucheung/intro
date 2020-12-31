require 'rails_helper'

describe Intro::ToursController, type: :controller do
  routes { Intro::Engine.routes }

  let(:unpublished_tour) { create(:intro_tour, controller_path: 'intro/admin/tours', action_name: 'new') }
  let(:published_tour) { create(:intro_tour, controller_path: 'intro/admin/tours', action_name: 'new', published:  true) }

  context 'unauthorized' do
    context '#index' do
      before do
        Intro::Tour.destroy_all
      end

      it 'should get unauthorized response if disable `visible_without_signing_in`' do
        revert_intro_config do
          Intro.config.visible_without_signing_in = false
          get :index, params: { controller_path: 'x', action_name: 'x' }, format: :json
          expect(response).to have_http_status(:unauthorized)
        end
      end

      it 'should get ok response if enable `visible_without_signing_in`' do
        revert_intro_config do
          Intro.config.visible_without_signing_in = true
          get :index, params: { controller_path: 'x', action_name: 'x' }, format: :json
          expect(response).to have_http_status(:ok)
        end
      end

      it 'should get empty data with publish tour diable not_sign_visible' do
        revert_intro_config do
          Intro.config.visible_without_signing_in = true
          published_tour

          get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new' }
          expect(response.successful?).to  be true
          expect(json_body).not_to be_nil
          expect(json_body[:data]).to be_empty
        end
      end

      it 'should get tours data with publish tour enable not_sign_visible' do
        revert_intro_config do
          Intro.config.visible_without_signing_in = true
          published_tour.options['not_sign_visible'] = true
          published_tour.save

          get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new' }
          expect(response.successful?).to  be true
          expect(json_body).not_to be_nil
          expect(json_body[:data]).not_to be_empty
        end
      end
    end

    context '#record' do
      it 'should get unauthorized response' do
        post :record, params: {id: 0}
        expect(response).to have_http_status(:unauthorized)
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
      before do
        Intro::Tour.destroy_all
      end

      it 'should get empty data with invalid controller, action' do
        get :index, params: { controller_path: 'x', action_name: 'x' }, format: :json
        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).to be_empty
      end

      it 'should get empty data with valid controller, action without published tour' do
        unpublished_tour

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new' }
        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).to be_empty
      end

      it 'should get tours data with valid controller, action and published record' do
        published_tour

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new' }
        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty
      end

      it 'should get empty data with valid controller, action and expired time' do
        published_tour.update(expired_at: 1.day.ago)

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new' }

        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).to be_empty
      end

      it 'should get empty data with valid controller, action and max_touch_count' do
        published_tour.tour_histories.create(user_id: User.first_or_create.id, touch_count: Intro.config.max_touch_count)

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new' }

        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).to be_empty
      end

      it 'should get tours data with valid controller, action without max_touch_count' do
        published_tour.tour_histories.create(user_id: User.first_or_create.id)

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new' }

        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty
      end

      it 'should get tours data with valid controller, action and same simple route on strict' do
        published_tour.update(route: { simple: '/intro/admin/tours/new', strict: true })

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: '/intro/admin/tours/new' }
        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: 'http://localhost:3000/intro/admin/tours/new' }
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty

        published_tour.update(route: { simple: 'http://localhost:3000/intro/admin/tours/new' })

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: 'http://localhost:3000/intro/admin/tours/new' }
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty

        published_tour.update(route: { simple: 'http://localhost:3000/intro/admin/tours/new?xyz=1' })

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: 'http://localhost:3000/intro/admin/tours/new?xyz=1' }
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty
      end

      it 'should get empty data with valid controller, action without same simple route on strict' do
        published_tour.update(route: { simple: '/intro/admin/tours/new', strict: true })

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: '/intro/admin/tours/new2' }
        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).to be_empty

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: 'http://localhost:3000/intro/admin/tours/new2' }
        expect(json_body).not_to be_nil
        expect(json_body[:data]).to be_empty

        published_tour.update(route: { simple: 'http://localhost:3000/intro/admin/tours/new' })

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: 'http://localhost:3000/intro/admin/tours/new2' }
        expect(json_body).not_to be_nil
        expect(json_body[:data]).to be_empty

        published_tour.update(route: { simple: 'http://localhost:3000/intro/admin/tours/new?xyz=1' })

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: 'http://localhost:3000/intro/admin/tours/new?xyz=2' }
        expect(json_body).not_to be_nil
        expect(json_body[:data]).to be_empty
      end

      it 'should get tours data with valid controller, action and path params' do
        published_tour.update(controller_path: 'intro/admin/tours', action_name: 'edit')

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'edit', original_url: '/intro/admin/tours/13/edit' }
        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty

        published_tour.update(controller_path: 'intro/admin/tours', action_name: 'edit', route: { simple: '/intro/admin/tours/13/edit' })

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'edit', original_url: '/intro/admin/tours/13/edit' }
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty
      end

      it 'should get empty data with valid controller, action without path params' do
        published_tour.update(controller_path: 'intro/admin/tours', action_name: 'edit')

        get :index, params: {controller_path: 'intro/admin/tours', action_name: 'edit', original_url: '/intro/admin/tours/13'}
        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).to be_empty

        published_tour.update(controller_path: 'intro/admin/tours', action_name: 'edit', route: { simple: '/intro/admin/tours/13/edit' })

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'edit', original_url: '/intro/admin/tours/13' }
        expect(json_body).not_to be_nil
        expect(json_body[:data]).to be_empty
      end

      it 'should get tours data with valid controller, action and query string' do
        published_tour

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: '/intro/admin/tours/new?xyz=1' }
        expect(response.successful?).to  be true
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty

        published_tour.update(route: { query: 'xyz=1' })

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: '/intro/admin/tours/new?xyz=1' }
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty

        get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new', original_url: '/intro/admin/tours/new?xyz=1&abc=2' }
        expect(json_body).not_to be_nil
        expect(json_body[:data]).not_to be_empty
      end

      it 'should get tour data with publish tour diable not_sign_visible' do
        revert_intro_config do
          Intro.config.visible_without_signing_in = true
          published_tour

          get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new' }
          expect(response.successful?).to  be true
          expect(json_body).not_to be_nil
          expect(json_body[:data]).not_to be_empty
        end
      end

      it 'should get tours data with publish tour enable not_sign_visible' do
        revert_intro_config do
          Intro.config.visible_without_signing_in = true
          published_tour.options['not_sign_visible'] = true
          published_tour.save

          get :index, params: { controller_path: 'intro/admin/tours', action_name: 'new' }
          expect(response.successful?).to  be true
          expect(json_body).not_to be_nil
          expect(json_body[:data]).not_to be_empty
        end
      end
    end

    context '#record' do
      it 'should get not_found without tour' do
        post :record, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end

      it 'should increment touch_count' do
        expect(published_tour.tour_histories).to be_empty
        expect { post :record, params: { id: published_tour.id } }.to change { published_tour.tour_histories.count }.by(1)
        expect(published_tour.tour_histories.first.touch_count).to eq 1
        expect(response.successful?).to  be true
      end
    end
  end
end