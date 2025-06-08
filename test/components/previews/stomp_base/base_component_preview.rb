# frozen_string_literal: true

# Base component preview for Stomp Base
module StompBase
  class BaseComponentPreview < ViewComponent::Preview
    # Default preview
    # @label Default
    def default
      render StompBase::BaseComponent.new
    end

    # With custom content
    # @label With Content
    def with_content
      render StompBase::BaseComponent.new do
        "Hello from Stomp Base!"
      end
    end
  end
end
