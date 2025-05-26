# frozen_string_literal: true

module StompBase
  module I18nHelper
    def t(key, options = {})
      # For StompBase-specific translation keys, automatically add prefix
      if key.is_a?(String) && !key.start_with?('stomp_base.')
        key = "stomp_base.#{key}"
      elsif key.is_a?(Symbol)
        key = "stomp_base.#{key}"
      end

      I18n.t(key, **options.merge(locale: StompBase.locale))
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
        'English'
      when :ja
        '日本語'
      else
        locale.to_s.capitalize
      end
    end
  end
end
