# frozen_string_literal: true

# Configure ViewComponent for Stomp Base
if defined?(ViewComponent)
  # Use the correct configuration approach for ViewComponent
  ViewComponent::Base.config.show_previews = Rails.env.development?
  ViewComponent::Base.config.default_preview_layout = "component_preview"

  ViewComponent::Base.config.preview_paths << Rails.root.join("test/components/previews") if Rails.env.development?
end
