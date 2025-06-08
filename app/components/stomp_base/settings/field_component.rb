# frozen_string_literal: true

module StompBase
  module Settings
    class FieldComponent < StompBase::BaseComponent
      def initialize(field_config:, form_data:)
        super()
        @icon_path = field_config[:icon_path]
        @label = field_config[:label]
        @description = field_config[:description]
        @field_name = field_config[:field_name]
        @options = field_config[:options]
        @current_value = form_data[:current_value]
        @form = form_data[:form]
      end

      private

      attr_reader :icon_path, :label, :description, :field_name, :options, :current_value, :form
    end
  end
end
