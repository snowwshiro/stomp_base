# frozen_string_literal: true

module StompBase
  module Dashboard
    class SystemOverviewCardComponent < StompBase::BaseComponent
      def initialize(system_info:)
        super()
        @system_info = system_info
      end

      def environment_badge_color
        case system_info[:environment]
        when "production"
          "bg-red-100 text-red-800 border-red-200"
        when "staging"
          "bg-yellow-100 text-yellow-800 border-yellow-200"
        when "development"
          "bg-green-100 text-green-800 border-green-200"
        else
          "bg-gray-100 text-gray-800 border-gray-200"
        end
      end

      private

      attr_reader :system_info
    end
  end
end
