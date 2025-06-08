# frozen_string_literal: true

# UI header component preview
module StompBase
  module Ui
    class HeaderComponentPreview < ViewComponent::Preview
      # Default header
      # @label Default
      def default
        render StompBase::Ui::HeaderComponent.new(title: "Sample Page")
      end

      # Header with subtitle
      # @label With Subtitle
      def with_subtitle
        render StompBase::Ui::HeaderComponent.new(
          title: "Main Title",
          subtitle: "This is a subtitle"
        )
      end
    end
  end
end
