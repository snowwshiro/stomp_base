# frozen_string_literal: true

module StompBase
  module I18nHelper
    def t(key, options = {})
      # For StompBase-specific translation keys, automatically add prefix
      key_string = key.to_s
      key = "stomp_base.#{key_string}" unless key_string.start_with?("stomp_base.")

      I18n.t(key, **options, locale: StompBase.locale)
    end

    def available_locales
      StompBase.configuration.available_locales
    end

    def current_locale
      StompBase.locale
    end

    def locale_name(locale)
      case locale.to_sym
      when :en
        "English"
      when :ja
        "日本語"
      else
        locale.to_s.capitalize
      end
    end
  end
end
