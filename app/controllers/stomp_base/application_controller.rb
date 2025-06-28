# frozen_string_literal: true

module StompBase
  class ApplicationController < ActionController::Base
    # Include necessary modules for API-only compatibility
    include ActionController::Cookies
    include ActionController::Flash unless included_modules.include?(ActionController::Flash)

    include StompBase::I18nHelper
    include StompBase::Authentication

    layout "stomp_base/application"

    before_action :set_locale

    # Add I18nHelper methods as helper methods
    helper_method :available_locales, :current_locale, :locale_name, :current_theme

    def index
      render plain: "StompBase Application Controller"
    end

    private

    def set_locale
      # Restore saved locale from session, or get from configuration if not found
      requested_locale = session[:stomp_base_locale] || StompBase.locale

      if StompBase.configuration.available_locales.include?(requested_locale.to_sym)
        I18n.locale = requested_locale
        StompBase.locale = requested_locale
      else
        I18n.locale = StompBase.locale
      end
    end

    def current_theme
      session[:stomp_base_theme] || "light"
    end
  end
end
