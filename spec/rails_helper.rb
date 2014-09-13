# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/webkit/matchers'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include ExampleHelper
  config.include CapybaraActionsHelper

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseRewinder.clean_all
  end

  begin_time = Time.zone.now.in_time_zone('Tokyo').at_beginning_of_day
  end_time   = Time.zone.now.in_time_zone('Tokyo').days_since(7).at_end_of_day

  config.before do
    DatabaseRewinder.strategy = :truncation
    DatabaseRewinder.start

    Period.create!(begin_time: begin_time, end_time: end_time)
    Postage.create!(cost: 450, border: 4000)
  end

  config.after :each do
    DatabaseRewinder.clean
    Timecop.return
  end

  config.include(Capybara::Webkit::RspecMatchers, type: :feature)

  config.infer_spec_type_from_file_location!
end

Capybara.javascript_driver = :webkit
