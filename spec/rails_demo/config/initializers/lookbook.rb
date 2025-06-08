if Rails.env.development?
  Rails.application.configure do
    config.lookbook.project_name = "StompBase Demo"
    config.lookbook.ui_theme = "blue"
    config.lookbook.auto_refresh = true
    config.lookbook.preview_disable_action_view_annotations = false
    
    # Add component preview paths
    config.lookbook.preview_paths = [
      Rails.root.join("test/components/previews")
    ]
  end
end
