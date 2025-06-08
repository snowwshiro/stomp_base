# frozen_string_literal: true

module StompBase
  module Models
    class SummaryCardComponent < StompBase::BaseComponent
      def initialize(table_name:, column_count:, total_count:)
        super()
        @table_name = table_name
        @column_count = column_count
        @total_count = total_count
      end

      private

      attr_reader :table_name, :column_count, :total_count
    end
  end
end
