# frozen_string_literal: true

# Console CSS component preview
module StompBase
  module Console
    class ConsoleCssComponentPreview < ViewComponent::Preview
      # Default CSS console
      # @label Default
      def default
        render StompBase::Console::ConsoleCssComponent.new
      end
    end
  end
end
