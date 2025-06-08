# frozen_string_literal: true

module StompBase
  module Pages
    class ModelDetailComponent < StompBase::BaseComponent
      def initialize(model_name:, model_class:, columns:, records:, pagination:)
        super()
        @model_name = model_name
        @model_class = model_class
        @columns = columns
        @records = records
        @pagination = pagination
      end

      def header_component
        StompBase::Ui::HeaderComponent.new(
          title: model_name,
          navigation: {
            back_path: helpers.stomp_base.models_path,
            back_label: t("stomp_base.models.list"),
            show_refresh: true
          }
        )
      end

      def summary_card_component
        StompBase::Models::SummaryCardComponent.new(
          table_name: @model_class.table_name,
          column_count: @columns.size,
          total_count: @pagination[:total_count]
        )
      end

      def data_table_component
        StompBase::Models::DataTableComponent.new(
          columns: @columns,
          records: @records,
          model_class: @model_class,
          current_page: @pagination[:current_page],
          total_pages: @pagination[:total_pages]
        )
      end

      def pagination_component
        StompBase::Ui::PaginationComponent.new(
          model_name: @model_name,
          current_page: @pagination[:current_page],
          total_pages: @pagination[:total_pages],
          per_page: @pagination[:per_page],
          total_count: @pagination[:total_count]
        )
      end

      private

      attr_reader :model_name, :model_class, :columns, :records, :pagination
    end
  end
end
