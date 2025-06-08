# frozen_string_literal: true

module StompBase
  module Console
    class ConsoleExamplesComponent < StompBase::BaseComponent
      EXAMPLES = [
        { key: "user_count", command: "User.count" },
        { key: "current_time", command: "Time.current" },
        { key: "rails_env", command: "Rails.env" },
        { key: "database_info", command: "ActiveRecord::Base.connection.adapter_name" }
      ].freeze

      def console_examples
        EXAMPLES.map do |example|
          {
            description: t("stomp_base.console.examples.#{example[:key]}"),
            command: example[:command]
          }
        end
      end
    end
  end
end
