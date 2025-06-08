# frozen_string_literal: true

module StompBase
  module Authentication
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_stomp_base, if: -> { StompBase.configuration.authentication_enabled? }
    end

    private

    def authenticate_stomp_base
      case StompBase.configuration.authentication_method
      when :basic_auth
        authenticate_with_basic_auth
      when :api_key
        authenticate_with_api_key
      when :custom
        authenticate_with_custom_method
      else
        render_authentication_error("Unknown authentication method")
      end
    end

    def authenticate_with_basic_auth
      authenticate_or_request_with_http_basic do |username, password|
        config = StompBase.configuration
        config.basic_auth_username == username && config.basic_auth_password == password
      end
    end

    def authenticate_with_api_key
      api_key = request.headers["X-API-Key"] || params[:api_key]

      return if api_key && StompBase.configuration.valid_api_keys.include?(api_key)

      render_authentication_error("Invalid or missing API key")
    end

    def authenticate_with_custom_method
      custom_authenticator = StompBase.configuration.custom_authenticator

      return if custom_authenticator&.call(request, params)

      render_authentication_error("Custom authentication failed")
    end

    def render_authentication_error(message = "Authentication required")
      respond_to do |format|
        format.html { render plain: message, status: :unauthorized }
        format.json { render json: { error: message }, status: :unauthorized }
        format.any { render plain: message, status: :unauthorized }
      end
    end
  end
end
