# frozen_string_literal: true

module StompBase
  module Pages
    class ConsoleComponent < StompBase::BaseComponent
      def initialize(title: nil)
        super()
        @title = title || t("stomp_base.console.title")
      end

      private

      attr_reader :title
    end
  end
end
