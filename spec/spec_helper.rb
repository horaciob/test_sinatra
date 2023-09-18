# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require_relative '../app'

require 'simplecov'

SimpleCov.start 'rails' do
  add_filter 'db/schema.rb'
  add_filter 'app/controllers/base_controller.rb'
  add_filter 'spec/**.rb'
  enable_coverage :branch

  minimum_coverage line: 95, branch: 80
end

DatabaseCleaner.strategy = :truncation

RSpec.configure do |c|
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :active_record
    end
  end
  c.include(Shoulda::Matchers::ActiveModel, type: :model)
  c.include(Shoulda::Matchers::ActiveRecord, type: :model)
  c.include Rack::Test::Methods, type: :controller
  c.include FactoryBot::Syntax::Methods

  c.before(:suite) do
    FactoryBot.find_definitions
  end

  c.before(:all) do
    DatabaseCleaner.clean
  end
  c.after do
    DatabaseCleaner.clean
  end
end
