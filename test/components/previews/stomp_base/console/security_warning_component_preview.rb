# frozen_string_literal: true

# Security warning component preview
module StompBase
  module Console
    class SecurityWarningComponentPreview < ViewComponent::Preview
      # Default security warning
      # @label Default
      def default
        render StompBase::Console::SecurityWarningComponent.new
      end
    end
  end
end
