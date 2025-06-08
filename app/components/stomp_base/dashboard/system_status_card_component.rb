# frozen_string_literal: true

module StompBase
  module Dashboard
    class SystemStatusCardComponent < StompBase::BaseComponent
      def initialize(performance_info:)
        super()
        @performance_info = performance_info
      end

      private

      attr_reader :performance_info
    end
  end
end
