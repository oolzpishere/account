# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

# require 'capybara/rails'
require 'capybara/minitest'
require 'mocha/minitest'
# wait Ajax request to return for 5 seconds, default is 2s.
# Capybara.default_max_wait_time = 5
# Capybara.app = MyRackApp

require 'webmock/minitest'

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
# ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __dir__)
require "rails/test_help"


# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
# Minitest.backtrace_filter = Minitest::BacktraceFilter.new


# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
