# frozen_string_literal: true

# Console examples component preview
module StompBase
  module Console
    class ConsoleExamplesComponentPreview < ViewComponent::Preview
      # Default examples
      # @label Default
      def default
        render StompBase::Console::ConsoleExamplesComponent.new
      end
    end
  end
end
