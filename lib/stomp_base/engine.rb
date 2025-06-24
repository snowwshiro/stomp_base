# frozen_string_literal: true

require "rails/engine"
require "active_record"
require "view_component"

module StompBase
  class Engine < ::Rails::Engine
    isolate_namespace StompBase

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.assets false
      g.helper true
    end

    # Add asset paths for Rails compatibility (when asset pipeline is available)
    config.after_initialize do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << root.join("app", "assets", "javascripts")
        app.config.assets.paths << root.join("app", "assets", "stylesheets")
        app.config.assets.paths << root.join("app", "javascript")

        # CSS precompilation (JavaScript is managed by importmap)
        app.config.assets.precompile += %w[stomp_base/application.css stomp_base/base.css]
      end
    end

    # I18n configuration
    config.before_configuration do
      I18n.load_path += Dir[Engine.root.join("config", "locales", "*.yml")]
    end

    initializer "stomp_base.set_locale" do |app|
      # Set locale based on StompBase configuration at application startup
      app.config.after_initialize do
        I18n.default_locale = StompBase.locale
      end
    end

    # Configure static asset serving for API-only Rails applications
    initializer "stomp_base.static_assets" do |app|
      if self.class.should_serve_static_assets?(app.config)
        app.middleware.use(
          ::ActionDispatch::Static,
          "#{root}/app/assets",
          headers: {
            "Cache-Control" => "public, max-age=31536000"
          }
        )
      end
    end

    # Configuration validation for StompBase compatibility
    initializer "stomp_base.validate_configuration" do |app|
      app.config.after_initialize do
        if app.config.api_only && !app.config.respond_to?(:assets)
          Rails.logger.info "StompBase: Detected API-only Rails application without asset pipeline"
          
          unless app.config.public_file_server.enabled
            Rails.logger.warn <<~WARNING
              ⚠️  StompBase Warning: Your API-only Rails application has public file server disabled.
              StompBase requires CSS assets to be served for proper UI functionality.
              
              To fix this, add to your config/application.rb or config/environments/#{Rails.env}.rb:
                config.public_file_server.enabled = true
              
              Or enable ActionView and asset pipeline by uncommenting in config/application.rb:
                require "action_view/railtie"
            WARNING
          else
            Rails.logger.info "StompBase: Configured static asset serving for API-only mode"
          end
        end
      end
    end

    # Check if we need to serve static assets (for API-only Rails apps)
    def self.should_serve_static_assets?(app_config)
      # Serve static assets if:
      # 1. The asset pipeline is not available (API-only mode)
      # 2. Public file server is enabled (default in development/test)
      !app_config.respond_to?(:assets) && app_config.public_file_server.enabled
    end
  end
end
