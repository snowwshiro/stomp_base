# frozen_string_literal: true

# Dashboard stats summary component preview
module StompBase
  module Dashboard
    class StatsSummaryComponentPreview < ViewComponent::Preview
      DEFAULT_SYSTEM_INFO = {
        ruby_version: "3.3.0",
        rails_version: "8.0.0",
        environment: "development"
      }.freeze

      DEFAULT_PERFORMANCE_INFO = {
        uptime_formatted: "3 days, 14 hours",
        memory: 512
      }.freeze

      # Default stats summary
      # @label Default
      def default
        render StompBase::Dashboard::StatsSummaryComponent.new(
          system_info: DEFAULT_SYSTEM_INFO,
          performance_info: DEFAULT_PERFORMANCE_INFO
        )
      end
    end
  end
end
