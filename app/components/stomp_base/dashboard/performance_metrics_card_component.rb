# frozen_string_literal: true

module StompBase
  module Dashboard
    class PerformanceMetricsCardComponent < StompBase::BaseComponent
      def initialize(performance_info:, memory_percentage:)
        super()
        @performance_info = performance_info
        @memory_percentage = memory_percentage
      end

      private

      attr_reader :performance_info, :memory_percentage
    end
  end
end
