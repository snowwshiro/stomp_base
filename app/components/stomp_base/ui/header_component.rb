# frozen_string_literal: true

module StompBase
  module Ui
    class HeaderComponent < StompBase::BaseComponent
      def initialize(title:, navigation: {}, display_options: {})
        super()
        @title = title
        @back_path = navigation[:back_path]
        @back_label = navigation[:back_label]
        @show_refresh = navigation[:show_refresh] || false
        @gradient_colors = display_options[:gradient_colors] || default_gradient_colors
        @status_message = display_options[:status_message]
        @custom_button = display_options[:custom_button]
        @icon = display_options[:icon]
      end

      private

      attr_reader :title, :back_path, :back_label, :show_refresh, :gradient_colors,
                  :status_message, :custom_button, :icon

      def default_gradient_colors
        { from: "#10b981", to: "#059669" }
      end

      def gradient_style
        "background: linear-gradient(135deg, #{gradient_colors[:from]} 0%, #{gradient_colors[:to]} 100%);"
      end

      def default_status_message
        "#{t("stomp_base.dashboard.last_updated")}: #{Time.current.strftime("%H:%M:%S")}"
      end
    end
  end
end
