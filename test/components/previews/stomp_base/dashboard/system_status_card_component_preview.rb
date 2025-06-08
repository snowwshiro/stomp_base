# frozen_string_literal: true

# Dashboard system status card component preview
module StompBase
  module Dashboard
    class SystemStatusCardComponentPreview < ViewComponent::Preview
      # Default system status
      # @label Default
      def default
        performance_info = {
          uptime_formatted: "3 days, 14 hours",
          memory: 512
        }

        render StompBase::Dashboard::SystemStatusCardComponent.new(performance_info: performance_info)
      end
    end
  end
end
