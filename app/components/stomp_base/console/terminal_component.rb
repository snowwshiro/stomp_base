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
        "Welcome to StompBase Rails Console\n" \
        "Type 'help' for available commands or 'exit' to quit\n\n"
      end
    end
  end
end