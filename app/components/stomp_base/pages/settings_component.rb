# frozen_string_literal: true

module StompBase
  module Pages
    class SettingsComponent < StompBase::BaseComponent
      def initialize(title: nil, current_locale: nil, current_theme: nil)
        super()
        @title = title || t("stomp_base.settings.title")
        @current_locale = current_locale || I18n.default_locale
        @current_theme = current_theme || "light"
      end

      def language_options
        [
          [t("stomp_base.settings.languages.japanese"), "ja"],
          [t("stomp_base.settings.languages.english"), "en"]
        ]
      end

      def theme_options
        [
          [t("stomp_base.settings.themes.light"), "light"],
          [t("stomp_base.settings.themes.dark"), "dark"]
        ]
      end

      def language_icon_path
        "M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 " \
          "10.77 8.07 15.61 3 18.129"
      end

      def theme_icon_path
        "M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
      end

      def form_url
        StompBase::Engine.routes.url_helpers.settings_path
      end

      private

      attr_reader :title, :current_locale, :current_theme
    end
  end
end
