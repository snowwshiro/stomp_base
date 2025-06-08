# frozen_string_literal: true

# UI action card component preview
module StompBase
  module Ui
    class ActionCardComponentPreview < ViewComponent::Preview
      BLUE_GRADIENT = {
        bg_from: "rgba(59, 130, 246, 0.1)",
        bg_to: "rgba(147, 51, 234, 0.1)",
        border: "rgba(59, 130, 246, 0.2)",
        icon_from: "rgb(59, 130, 246)",
        icon_to: "rgb(147, 51, 234)",
        shadow: "rgba(59, 130, 246, 0.25)",
        status_color: "rgb(59, 130, 246)"
      }.freeze

      GREEN_GRADIENT = {
        bg_from: "rgba(34, 197, 94, 0.1)",
        bg_to: "rgba(20, 184, 166, 0.1)",
        border: "rgba(34, 197, 94, 0.2)",
        icon_from: "rgb(34, 197, 94)",
        icon_to: "rgb(20, 184, 166)",
        shadow: "rgba(34, 197, 94, 0.25)",
        status_color: "rgb(34, 197, 94)"
      }.freeze

      ORANGE_GRADIENT = {
        bg_from: "rgba(249, 115, 22, 0.1)",
        bg_to: "rgba(239, 68, 68, 0.1)",
        border: "rgba(249, 115, 22, 0.2)",
        icon_from: "rgb(249, 115, 22)",
        icon_to: "rgb(239, 68, 68)",
        shadow: "rgba(249, 115, 22, 0.25)",
        status_color: "rgb(249, 115, 22)"
      }.freeze

      SAMPLE_CONTENT = {
        title: "Sample Action",
        description: "This is a sample action card",
        icon: "🚀"
      }.freeze

      SAMPLE_ACTION = {
        text: "Get Started",
        url: "#"
      }.freeze

      STATUS_CONTENT = {
        title: "System Status",
        description: "Monitor your application health",
        icon: "📊"
      }.freeze

      STATUS_ACTION = {
        text: "View Details",
        url: "/dashboard"
      }.freeze

      # Default action card
      # @label Default
      def default
        render StompBase::Ui::ActionCardComponent.new(
          card_content: SAMPLE_CONTENT,
          action: SAMPLE_ACTION,
          display_options: { gradient_colors: BLUE_GRADIENT }
        )
      end

      # Action card with status
      # @label With Status
      def with_status
        render StompBase::Ui::ActionCardComponent.new(
          card_content: STATUS_CONTENT,
          action: STATUS_ACTION,
          display_options: {
            gradient_colors: GREEN_GRADIENT,
            status: "success",
            status_text: "All systems operational"
          }
        )
      end

      # Action card with different colors
      # @label Different Colors
      def different_colors
        render StompBase::Ui::ActionCardComponent.new(
          card_content: { title: "Configuration", description: "Manage application settings", icon: "⚙️" },
          action: { text: "Configure", url: "/settings" },
          display_options: { gradient_colors: ORANGE_GRADIENT }
        )
      end
    end
  end
end
