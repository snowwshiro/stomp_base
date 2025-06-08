# frozen_string_literal: true

# Console JavaScript component preview
module StompBase
  module Console
    class ConsoleJavascriptComponentPreview < ViewComponent::Preview
      # Default JavaScript console
      # @label Default
      def default
        render StompBase::Console::ConsoleJavascriptComponent.new
      end
    end
  end
end
