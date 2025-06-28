# frozen_string_literal: true

module StompBase
  class Configuration
    attr_accessor :available_locales,
                  :authentication_enabled, :authentication_method,
                  :basic_auth_username, :basic_auth_password,
                  :valid_api_keys, :custom_authenticator,
                  :allowed_ips,
                  :allow_console_in_production

    attr_reader :locale

    def initialize
      @locale = :en
      @available_locales = %i[en ja]
      @authentication_enabled = false
      @authentication_method = :basic_auth
      @basic_auth_username = nil
      @basic_auth_password = nil
      @valid_api_keys = []
      @custom_authenticator = nil
      @allowed_ips = []
      @allow_console_in_production = false # Whether to allow console functionality in production environment
    end

    def locale=(new_locale)
      new_locale = new_locale.to_sym
      unless @available_locales.include?(new_locale)
        raise ArgumentError, "Unsupported locale: #{new_locale}. Available locales: #{@available_locales.join(", ")}"
      end

      @locale = new_locale
    end

    def authentication_enabled?
      @authentication_enabled
    end

    def enable_authentication(method: :basic_auth, **options)
      @authentication_enabled = true
      @authentication_method = method
      configure_authentication_method(method, options)
    end

    def disable_authentication
      @authentication_enabled = false
    end

    private

    def configure_authentication_method(method, options)
      case method
      when :basic_auth
        configure_basic_auth(options)
      when :api_key
        configure_api_key(options)
      when :custom
        configure_custom_auth(options)
      when :ip_auth
        configure_ip_auth(options)
      else
        raise ArgumentError, "Unsupported authentication method: #{method}"
      end
    end

    def configure_basic_auth(options)
      @basic_auth_username = options[:username]
      @basic_auth_password = options[:password]
      validate_basic_auth_config
    end

    def configure_api_key(options)
      @valid_api_keys = Array(options[:keys])
      validate_api_key_config
    end

    def configure_custom_auth(options)
      @custom_authenticator = options[:authenticator]
      validate_custom_auth_config
    end

    def configure_ip_auth(options)
      @allowed_ips = Array(options[:allowed_ips])
      validate_ip_auth_config
    end

    def validate_basic_auth_config
      return unless @basic_auth_username.nil? || @basic_auth_password.nil?

      raise ArgumentError, "Basic auth requires both username and password"
    end

    def validate_api_key_config
      return unless @valid_api_keys.empty?

      raise ArgumentError, "API key authentication requires at least one valid key"
    end

    def validate_custom_auth_config
      return if @custom_authenticator.respond_to?(:call)

      raise ArgumentError, "Custom authenticator must be a callable object"
    end

    def validate_ip_auth_config
      return unless @allowed_ips.empty?

      raise ArgumentError, "IP authentication requires at least one allowed IP address or range"
    end
  end
end
