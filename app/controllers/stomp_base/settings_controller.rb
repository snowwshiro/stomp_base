# frozen_string_literal: true

module StompBase
  class SettingsController < StompBase::ApplicationController
    # Disable Rails default layout to use LayoutComponent
    layout false

    def index
      # Display settings screen
    end

    def update
      update_locale_setting(params[:locale]) if params[:locale]

      update_theme_setting(params[:theme]) if params[:theme]

      redirect_back(fallback_location: stomp_base.root_path, notice: t("stomp_base.settings.settings_updated"))
    end

    def update_locale
      locale = params[:locale]

      if valid_locale?(locale)
        update_user_locale(locale)
        render_success_response(locale)
      else
        render_error_response
      end
    end

    private

    def valid_locale?(locale)
      StompBase.configuration.available_locales.include?(locale.to_sym)
    end

    def update_user_locale(locale)
      StompBase.locale = locale
      session[:stomp_base_locale] = locale
    end

    def render_success_response(locale)
      respond_to do |format|
        format.json { render json: { status: "success", locale: locale } }
        format.html do
          redirect_back(fallback_location: stomp_base.root_path, notice: t("stomp_base.settings.settings_updated"))
        end
      end
    end

    def render_error_response
      respond_to do |format|
        format.json do
          render json: { status: "error", message: t("stomp_base.settings.invalid_locale") },
                 status: :unprocessable_entity
        end
        format.html do
          redirect_back(fallback_location: stomp_base.root_path, alert: t("stomp_base.settings.invalid_locale"))
        end
      end
    end

    def update_locale_setting(locale)
      return unless StompBase.configuration.available_locales.include?(locale.to_sym)

      StompBase.locale = locale
      session[:stomp_base_locale] = locale
    end

    def update_theme_setting(theme)
      # List of valid themes
      valid_themes = %w[light dark]

      return unless valid_themes.include?(theme)

      session[:stomp_base_theme] = theme
    end
  end
end
