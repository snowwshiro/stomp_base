# frozen_string_literal: true

module StompBase
  module Console
    class TerminalComponent < StompBase::BaseComponent
      def initialize(session_id: nil)
        super()
        @session_id = session_id || SecureRandom.hex(8)
      end

      private

      attr_reader :session_id

      def initial_prompt
        "irb(main):001:0> "
      end

      def welcome_message
        "#{t("stomp_base.console.terminal_welcome")}\n#{t("stomp_base.console.terminal_help")}"
      end
    end
  end
end
