# frozen_string_literal: true

module StompBase
  module Ui
    class PaginationComponent < StompBase::BaseComponent
      def initialize(model_name:, current_page:, total_pages:, per_page:, total_count:)
        super()
        @model_name = model_name
        @current_page = current_page
        @total_pages = total_pages
        @per_page = per_page
        @total_count = total_count
      end

      def pagination?
        @total_pages > 1
      end

      def previous_page?
        @current_page > 1
      end

      def next_page?
        @current_page < @total_pages
      end

      def previous_page_offset
        (@current_page - 2) * @per_page
      end

      def next_page_offset
        @current_page * @per_page
      end

      private

      attr_reader :model_name, :current_page, :total_pages, :per_page, :total_count
    end
  end
end
