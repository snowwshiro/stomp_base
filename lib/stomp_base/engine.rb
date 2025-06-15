# frozen_string_literal: true

require "rails/engine"
require "active_record"
require "view_component"
require "tailwindcss/rails"

module StompBase
  class Engine < ::Rails::Engine
    isolate_namespace StompBase

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.assets false
      g.helper true
    end

    # Add asset paths for Rails 8 compatibility
    if defined?(Rails.application.config.assets)
      config.assets.paths << root.join("app", "assets", "javascripts")
      config.assets.paths << root.join("app", "assets", "stylesheets")
      config.assets.paths << root.join("app", "javascript")

      # CSS precompilation (JavaScript is managed by importmap)
      config.assets.precompile += %w[stomp_base/application.css stomp_base/application.tailwind.css stomp_base/base.css]
    end

    # Tailwind CSS configuration
    initializer "stomp_base.tailwind" do |app|
      if defined?(Tailwindcss::Rails)
        # Add our Tailwind config file to the search path
        Tailwindcss::Rails.configure do |config|
          config.config_file = Engine.root.join("config", "tailwind.config.js")
        end
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
  end
end
