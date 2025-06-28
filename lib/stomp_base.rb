# frozen_string_literal: true

require "stomp_base/version"
require "stomp_base/configuration"
require "stomp_base/i18n_helper"
require "stomp_base/ip_authentication_service"

# Only load Rails-dependent modules if Rails is available
if defined?(Rails)
  require "active_record"
  require "view_component"
  require "stomp_base/engine"
  require "stomp_base/authentication"
end

module StompBase
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.locale
    configuration.locale
  end

  def self.locale=(locale)
    configuration.locale = locale
  end

  # Authentication configuration helper methods
  def self.enable_authentication(**options)
    configuration.enable_authentication(**options)
  end

  def self.disable_authentication
    configuration.disable_authentication
  end

  def self.authentication_enabled?
    configuration.authentication_enabled?
  end
end
