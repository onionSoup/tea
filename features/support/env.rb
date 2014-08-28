ENV["RAILS_ENV"] ||= "test"

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'

DatabaseRewinder.strategy = :truncation

World FactoryGirl::Syntax::Methods

Capybara.default_selector = :css

Before do
  ActiveRecord::FixtureSet.reset_cache
  fixtures_folder = File.join(Rails.root, 'spec', 'fixtures')
  fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
  ActiveRecord::FixtureSet.create_fixtures(fixtures_folder, fixtures)
end
