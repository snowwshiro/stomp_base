# frozen_string_literal: true

module StompBase
  module Settings
    class FormActionsComponent < StompBase::BaseComponent
      def initialize(form:, form_url:)
        super()
        @form = form
        @form_url = form_url
      end

      private

      attr_reader :form, :form_url
    end
  end
end
