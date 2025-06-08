# frozen_string_literal: true

module StompBase
  module Dashboard
    class RuntimeInfoCardComponent < StompBase::BaseComponent
      def initialize(system_info:)
        super()
        @system_info = system_info
      end

      private

      attr_reader :system_info
    end
  end
end
