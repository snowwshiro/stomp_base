# frozen_string_literal: true

# Lookbook configuration for Stomp Base components
# Only configure if Lookbook is available
if defined?(Lookbook)
  Lookbook.configure do |config|
    # Set the project name that will be displayed in the UI
    config.project_name = "Stomp Base Components"

    # Enable or disable auto-refresh of the preview browser when files change
    config.auto_refresh = Rails.env.development?

    # Set the listening host and port for the preview server
    config.preview_host = "localhost"
    config.preview_port = 3000

    # Configure component paths - add directories where your components live
    config.component_paths = [
      Rails.root.join("app/components")
    ]

    # Configure page paths - for any standalone preview pages
    config.page_paths = [
      Rails.root.join("test/components/previews/pages")
    ]

    # Enable experimental features if needed
    config.experimental_features = false

    # Set the default layout for previews (use minimal layout without navigation)
    config.preview_layout = "lookbook/minimal"

    # Set up component file extensions to watch
    config.listen_extensions = %w[rb erb html haml slim]

    # Configure inspector - allows viewing of component source, etc.
    config.inspector_enabled = false

    # Log level for lookbook operations
    config.log_level = :info
  end
end
