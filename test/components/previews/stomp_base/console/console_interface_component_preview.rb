# frozen_string_literal: true

# Console interface component preview
module StompBase
  module Console
    class ConsoleInterfaceComponentPreview < ViewComponent::Preview
      # Default interface
      # @label Default
      def default
        render StompBase::Console::ConsoleInterfaceComponent.new
      end
    end
  end
end
