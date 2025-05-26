# frozen_string_literal: true

module StompBase
  class Configuration
    attr_accessor :locale, :available_locales,
                  :authentication_enabled, :authentication_method,
                  :basic_auth_username, :basic_auth_password,
                  :valid_api_keys, :custom_authenticator

    def initialize
      @locale = :en
      @available_locales = %i[en ja]
      @authentication_enabled = false
      @authentication_method = :basic_auth
      @basic_auth_username = nil
      @basic_auth_password = nil
      @valid_api_keys = []
      @custom_authenticator = nil
    end

    def locale=(locale)
      locale = locale.to_sym
      unless @available_locales.include?(locale)
        raise ArgumentError, "Unsupported locale: #{locale}. Available locales: #{@available_locales.join(', ')}"
      end
      @locale = locale
    end

    def authentication_enabled?
      @authentication_enabled
    end

    def enable_authentication(method: :basic_auth, **options)
      @authentication_enabled = true
      @authentication_method = method

      case method
      when :basic_auth
        @basic_auth_username = options[:username]
        @basic_auth_password = options[:password]
        validate_basic_auth_config
      when :api_key
        @valid_api_keys = Array(options[:keys])
        validate_api_key_config
      when :custom
        @custom_authenticator = options[:authenticator]
        validate_custom_auth_config
      else
        raise ArgumentError, "Unsupported authentication method: #{method}"
      end
    end

    def disable_authentication
      @authentication_enabled = false
    end

    private

    def validate_basic_auth_config
      if @basic_auth_username.nil? || @basic_auth_password.nil?
        raise ArgumentError, "Basic auth requires both username and password"
      end
    end

    def validate_api_key_config
      if @valid_api_keys.empty?
        raise ArgumentError, "API key authentication requires at least one valid key"
      end
    end

    def validate_custom_auth_config
      unless @custom_authenticator.respond_to?(:call)
        raise ArgumentError, "Custom authenticator must be a callable object"
      end
    end
  end
end
