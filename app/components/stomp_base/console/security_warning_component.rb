# frozen_string_literal: true

module StompBase
  module Console
    class SecurityWarningComponent < StompBase::BaseComponent
      def environment_warning_color
        case Rails.env
        when "production"
          "bg-red-100 border-red-200 text-red-800"
        when "staging"
          "bg-yellow-100 border-yellow-200 text-yellow-800"
        else
          "bg-blue-100 border-blue-200 text-blue-800"
        end
      end

      def production?
        Rails.env.production?
      end
    end
  end
end
