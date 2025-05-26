require "stomp_base/version"
require "stomp_base/configuration"
require "stomp_base/i18n_helper"

# Only load Rails-dependent modules if Rails is available
if defined?(Rails)
  require "stomp_base/engine"
  require "stomp_base/authentication"
end

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

  def self.locale=(locale)
    configuration.locale = locale
  end

  # 認証設定のヘルパーメソッド
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
