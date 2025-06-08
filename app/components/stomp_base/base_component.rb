# frozen_string_literal: true

require "view_component" unless defined?(ViewComponent)

module StompBase
  class BaseComponent < ViewComponent::Base
    def render?
      true
    end

    def call
      content_tag :div, class: "stomp-base-component" do
        "Base Component"
      end
    end

    private

    def t(key, **options)
      # Convert key to string for consistent processing
      key_str = key.to_s

      # If key already starts with 'stomp_base.', don't add scope to avoid duplication
      if key_str.start_with?("stomp_base.")
        I18n.t(key, **options)
      else
        # Add stomp_base scope for keys that don't already have it
        I18n.t(key, scope: [:stomp_base], **options)
      end
    end
  end
end
