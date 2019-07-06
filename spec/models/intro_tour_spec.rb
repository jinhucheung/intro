require 'spec_helper'

describe Intro::Tour, type: :model do
  context 'associations' do
    it { should have_many :tour_histories }
  end

  context 'validations' do
    it { should validate_presence_of(:ident) }

    it { should validate_uniqueness_of(:ident) }
  end

  context 'create' do
    it { should serialize(:route) }

    it { should serialize(:options) }
  end
end