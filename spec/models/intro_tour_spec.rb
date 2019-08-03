require 'spec_helper'

describe Intro::Tour, type: :model do
  let(:tour) { create(:intro_tour) }
  let(:new_tour) { build(:intro_tour) }

  context 'associations' do
    it { should have_many :tour_histories }
  end

  context 'validations' do
    it { should validate_presence_of(:ident) }

    it { should validate_uniqueness_of(:ident) }
  end

  context 'serialize' do
    it { should serialize(:route) }

    it { should serialize(:options) }
  end

  context 'create' do
    it 'tour is invalid without ident' do
      tour = Intro::Tour.new
      expect(tour.valid?).to be false
    end

    it 'tour is invalid with same ident' do
      another = tour.dup
      expect(another.valid?).to be false
    end

    it 'tour is valid with uniq ident' do
      expect(tour.valid?).to be true
    end

    it 'tour should include controller and action with ident and valid simple path' do
      new_tour.route[:simple] = '/intro/admin/tours/new?source=test'
      expect(new_tour.save).to be true
      expect(new_tour.controller_path).to eq 'intro/admin/tours'
      expect(new_tour.action_name).to eq 'new'
      expect(new_tour.simple_route).to eq '/intro/admin/tours/new?source=test'
      expect(new_tour.route[:query]).to eq 'source=test'
    end

    it 'tour should not include controller or action with ident and invalid simple path' do
      new_tour.route[:simple] = '/intro/admin/test'
      expect(new_tour.save).to be true
      expect(new_tour.controller_path).to be_empty
      expect(new_tour.action_name).to be_empty
    end

    it 'tour should be strict with TRUE boolean strict' do
      new_tour.route[:strict] = '1'
      expect(new_tour.save).to be true
      expect(new_tour.strict_route?).to be true

      new_tour.route[:strict] = 'true'
      expect(new_tour.save).to be true
      expect(new_tour.strict_route?).to be true

      new_tour.route[:strict] = true
      expect(new_tour.save).to be true
      expect(new_tour.strict_route?).to be true
    end

    it 'custom controller should be present after passing controller' do
      new_tour.route[:simple]  = '/intro/admin/tours/new?source=test'
      new_tour.controller_path = 'tours'
      new_tour.save
      expect(new_tour.controller_path).to eq 'tours'
    end

    it 'custom action should be present after passing action' do
      new_tour.route[:simple]  = '/intro/admin/tours/new?source=test'
      new_tour.action_name = 'create'
      new_tour.save
      expect(new_tour.action_name).to eq 'create'
    end

    it 'custom query should be present after passing query' do
      new_tour.route[:simple]  = '/intro/admin/tours/new?source=test'
      new_tour.route[:query] = 'source=demo'
      new_tour.save
      expect(new_tour.route[:query]).to eq 'source=demo'
    end
  end

  context '::extract_route' do
    it 'get controller and action from path' do
      route = Intro::Tour.extract_route('/intro/admin/tours/new')
      expect(route[:source].is_a?(Hash)).to be true
      expect(route[:source]).to include(controller: 'intro/admin/tours', action: 'new')
    end

    it 'get controller and action from url' do
      route = Intro::Tour.extract_route('http://localhost:3000/intro/admin/tours/new')
      expect(route[:source].is_a?(Hash)).to be true
      expect(route[:source]).to include(controller: 'intro/admin/tours', action: 'new')
    end

    it 'get query from path which include query string' do
      route = Intro::Tour.extract_route('/intro/admin/tours/new?source=test')
      expect(route[:query]).to eq 'source=test'
    end

    it 'not controller and action from non-existed path' do
      route = Intro::Tour.extract_route('/intro/admin/test')
      expect(route[:source]).to be_nil
    end
  end

  context '#expose_attributes' do
    it 'should include id, ident, controller_path, action_name and options' do
      exposed_attrs = tour.expose_attributes
      expect(exposed_attrs).to have_key(:id)
      expect(exposed_attrs).to have_key(:ident)
      expect(exposed_attrs).to have_key(:controller_path)
      expect(exposed_attrs).to have_key(:action_name)
      expect(exposed_attrs).to have_key(:options)
    end
  end

  context '#simple_route' do
    it 'should be present with simple route' do
      tour.route[:simple] = '/intro/admin/tours'
      expect(tour.simple_route).not_to be_empty
    end

    it 'simple_route_changed should return true after changing simple route' do
      tour.route[:simple] = '/intro/admin/tours'
      tour.save
      expect(tour.simple_route_changed?).to be false

      tour.route[:simple] = '/intro/admin/tours'
      expect(tour.simple_route_changed?).to be false

      tour.route[:simple] = '/intro/admin/tours/1'
      expect(tour.simple_route_changed?).to be true
    end
  end

  context '#expired' do
    it 'should be active when expired_at is nil' do
      expect(tour.expired?).to be false
    end

    it 'should be expired when expired_at less than current time' do
      tour.expired_at = 1.day.ago
      expect(tour.expired?).to be true
    end

    it 'should be active when expired_at more than current time' do
      tour.expired_at = 1.day.since
      expect(tour.expired?).to be false
    end
  end
end