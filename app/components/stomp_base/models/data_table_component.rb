# frozen_string_literal: true

module StompBase
  module Models
    class DataTableComponent < StompBase::BaseComponent
      TYPE_COLORS = {
        string: "bg-blue-100 text-blue-700",
        text: "bg-blue-100 text-blue-700",
        integer: "bg-green-100 text-green-700",
        bigint: "bg-green-100 text-green-700",
        decimal: "bg-purple-100 text-purple-700",
        float: "bg-purple-100 text-purple-700",
        boolean: "bg-yellow-100 text-yellow-700",
        datetime: "bg-pink-100 text-pink-700",
        timestamp: "bg-pink-100 text-pink-700",
        date: "bg-indigo-100 text-indigo-700",
        default: "bg-gray-100 text-gray-600"
      }.freeze

      def initialize(columns:, records:, model_class:, current_page: nil, total_pages: nil)
        super()
        @columns = columns
        @records = records
        @model_class = model_class
        @current_page = current_page
        @total_pages = total_pages
      end

      def pagination?
        @total_pages && @total_pages > 1
      end

      def format_cell_value(value)
        return content_tag(:span, "NULL", style: "color: #6c757d; font-style: italic;") if value.nil?

        if value.is_a?(String) && value.length > 50
          content_tag(:span, "#{value[0..50]}...", title: value)
        else
          value.to_s
        end
      end

      def column_type_badge_color(column_name)
        column = find_column(column_name)
        return TYPE_COLORS[:default] unless column

        TYPE_COLORS[column.type] || TYPE_COLORS[:default]
      end

      def column_type(column_name)
        column = find_column(column_name)
        column&.type ? column.type.to_s.upcase : "UNKNOWN"
      end

      private

      attr_reader :columns, :records, :model_class, :current_page, :total_pages

      def find_column(column_name)
        @model_class.columns.find { |c| c.name == column_name }
      end
    end
  end
end
