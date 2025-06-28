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

          if app.config.public_file_server.enabled
            Rails.logger.info "StompBase: Configured static asset serving for API-only mode"
          else
            Rails.logger.warn <<~WARNING
              ⚠️  StompBase Warning: Your API-only Rails application has public file server disabled.
              StompBase requires CSS assets to be served for proper UI functionality.

              To fix this, add to your config/application.rb or config/environments/#{Rails.env}.rb:
                config.public_file_server.enabled = true

              Or enable ActionView and asset pipeline by uncommenting in config/application.rb:
                require "action_view/railtie"
            WARNING
          end
        end
      end
    end

    # Configure middleware for API-only Rails applications
    initializer "stomp_base.api_middleware", before: :build_middleware_stack do |app|
      if app.config.api_only
        Rails.logger.info "StompBase: Configuring middleware for API-only Rails application"

        # Add necessary middleware for StompBase compatibility
        required_middleware = [
          [Rack::MethodOverride, []],
          [ActionDispatch::Cookies, []],
          [ActionDispatch::Session::CookieStore, []],
          [ActionDispatch::Flash, []]
        ]

        required_middleware.each do |middleware_class, args|
          app.config.middleware.use middleware_class, *args
          Rails.logger.debug { "StompBase: Added #{middleware_class} middleware" }
        rescue ArgumentError => e
          # Middleware might already be present
          Rails.logger.debug { "StompBase: #{middleware_class} middleware already present or error: #{e.message}" }
        end

        Rails.logger.info "StompBase: Middleware configuration completed"
      end
    end

    # Configure session store for API-only Rails applications
    initializer "stomp_base.session_store" do |app|
      if app.config.api_only && !Rails.application.config.session_store
        app.config.session_store :cookie_store, key: "_#{Rails.application.class.module_parent_name.underscore}_session"
        Rails.logger.info "StompBase: Configured cookie session store for API-only application"
      end
    end

    # Check if we need to serve static assets (for API-only Rails apps)
    def self.should_serve_static_assets?(app_config)
      # Serve static assets if:
      # 1. The asset pipeline is not available (API-only mode)
      # 2. Public file server is enabled (default in development/test)
      !app_config.respond_to?(:assets) && app_config.public_file_server.enabled
    end

    # Check for ActionView availability and provide guidance
    initializer "stomp_base.actionview_check", after: :load_config_initializers do |app|
      if app.config.api_only
        if defined?(ActionView::Railtie) && Rails.application.config.railties_order.include?(ActionView::Railtie)
          Rails.logger.info "StompBase: ActionView railtie detected - full UI functionality available"
        else
          Rails.logger.warn <<~WARNING
            ⚠️  StompBase Notice: ActionView railtie is not loaded.
            StompBase requires ActionView for rendering UI components.

            To enable ActionView, uncomment this line in your config/application.rb:
              require "action_view/railtie"

            StompBase will attempt to function with limited capabilities.
          WARNING
        end
      end
    end
  end
end
