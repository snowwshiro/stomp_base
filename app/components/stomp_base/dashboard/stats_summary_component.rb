# frozen_string_literal: true

module StompBase
  module Dashboard
    class StatsSummaryComponent < StompBase::BaseComponent
      def initialize(system_info:, performance_info:)
        super()
        @system_info = system_info
        @performance_info = performance_info
      end

      private

      attr_reader :system_info, :performance_info
    end
  end
end
