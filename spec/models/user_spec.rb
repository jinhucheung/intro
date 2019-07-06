require 'spec_helper'

describe Intro.config.user_class.classify.constantize, type: :model do
  context 'associations' do
    it { should have_many :intro_tour_histories }
  end
end