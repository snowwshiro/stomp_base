# frozen_string_literal: true

module StompBase
  module Ui
    class ActionCardComponent < StompBase::BaseComponent
      def initialize(card_content:, action:, display_options:)
        super()
        @title = card_content[:title]
        @description = card_content[:description]
        @action_text = action[:text]
        @action_url = action[:url]
        @icon = card_content[:icon]
        @gradient_colors = display_options[:gradient_colors]
        @status = display_options[:status]
        @status_text = display_options[:status_text]
      end

      def show_status?
        @status.present? && @status_text.present?
      end

      def status_indicator_class
        case @status
        when :active
          "status-active"
        when :warning
          "status-warning"
        when :error
          "status-error"
        else
          "status-inactive"
        end
      end

      private

      attr_reader :title, :description, :action_text, :action_url, :icon, :gradient_colors
    end
  end
end
