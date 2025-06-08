# frozen_string_literal: true

# Dashboard performance metrics card component preview
module StompBase
  module Dashboard
    class PerformanceMetricsCardComponentPreview < ViewComponent::Preview
      # Default performance metrics
      # @label Default
      def default
        performance_info = {
          uptime_formatted: "3 days, 14 hours",
          memory: 512
        }

        memory_percentage = 67.5

        render StompBase::Dashboard::PerformanceMetricsCardComponent.new(
          performance_info: performance_info,
          memory_percentage: memory_percentage
        )
      end
    end
  end
end
