require 'spec_helper'
require 'shoulda/matchers'


describe Intro::TourHistory, type: :model do
  let(:history) { create(:intro_tour_history) }

  context 'associations' do
    it { should belong_to :user }

    it { should belong_to :tour }
  end

  context 'validations' do
    it { should validate_presence_of(:user) }

    it { should validate_presence_of(:tour) }
  end

  context 'create' do
    it 'increment count after touching tour' do
      expect(history.touch_count).to eq 0

      history.increment!(:touch_count)

      expect(history.touch_count).to eq 1
    end
  end
end