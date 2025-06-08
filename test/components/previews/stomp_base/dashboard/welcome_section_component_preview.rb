# frozen_string_literal: true

# Dashboard welcome section component preview
module StompBase
  module Dashboard
    class WelcomeSectionComponentPreview < ViewComponent::Preview
      # Default welcome section
      # @label Default
      def default
        render StompBase::Dashboard::WelcomeSectionComponent.new
      end
    end
  end
end
