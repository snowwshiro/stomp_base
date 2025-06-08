# frozen_string_literal: true

module StompBase
  module Pages
    class ModelsListComponent < StompBase::BaseComponent
      BADGE_COLORS = {
        empty: "bg-gray-100 text-gray-600 border-gray-300",
        small: "bg-green-100 text-green-700 border-green-300",
        medium: "bg-blue-100 text-blue-700 border-blue-300",
        large: "bg-yellow-100 text-yellow-700 border-yellow-300",
        extra_large: "bg-red-100 text-red-700 border-red-300"
      }.freeze

      def initialize(models:)
        super()
        @models = models
      end

      private

      attr_reader :models

      def models_count
        models.size
      end

      def total_records
        models.sum { |model| model[:record_count] }
      end

      def total_columns
        models.sum { |model| model[:column_count] }
      end

      def model_badge_color(record_count)
        case record_count
        when 0 then BADGE_COLORS[:empty]
        when 1..100 then BADGE_COLORS[:small]
        when 101..1000 then BADGE_COLORS[:medium]
        when 1001..10_000 then BADGE_COLORS[:large]
        else BADGE_COLORS[:extra_large]
        end
      end
    end
  end
end
