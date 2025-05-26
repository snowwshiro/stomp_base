# Rails helper for controller and integration tests
require 'spec_helper'

# Set up test environment
ENV['RAILS_ENV'] = 'test'

# Load Rails and components in correct order
require 'rails'
require 'action_controller/railtie'
require 'active_support/all'

# Create a minimal Rails application for testing
class TestApplication < Rails::Application
  config.load_defaults 7.0
  config.eager_load = false
  config.secret_key_base = 'test_secret_key_base'
  config.active_support.deprecation = :log
  config.log_level = :fatal
  config.root = File.expand_path('..', __dir__)
  config.action_controller.allow_forgery_protection = false
  config.consider_all_requests_local = true
  
  # Setup minimal routes
  routes.draw do
    # Test routes will be added dynamically
  end
end

# Initialize Rails application
Rails.application = TestApplication.new
Rails.application.initialize!

# Load rspec-rails
require 'rspec/rails'

# Load StompBase modules manually for testing
require File.expand_path('../lib/stomp_base/version', __dir__)
require File.expand_path('../lib/stomp_base/configuration', __dir__)
require File.expand_path('../lib/stomp_base/i18n_helper', __dir__)
require File.expand_path('../lib/stomp_base/authentication', __dir__)

# Set up StompBase module structure
module StompBase
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.locale
    configuration.locale
  end

  def self.locale=(value)
    configuration.locale = value
  end
end

# Load engine controllers manually
require File.expand_path('../app/controllers/stomp_base/application_controller.rb', __dir__)
require File.expand_path('../app/controllers/stomp_base/dashboard_controller.rb', __dir__)

# Configure RSpec for Rails
RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  
  config.before(:each, type: :controller) do
    @routes = ActionDispatch::Routing::RouteSet.new
  end
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Reset configuration before each test
  config.before(:each) do
    StompBase.instance_variable_set(:@configuration, nil)
  end
end
