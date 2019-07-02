require 'test_helper'
require 'generators/intro/intro_generator'

module Intro
  class IntroGeneratorTest < Rails::Generators::TestCase
    tests IntroGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
