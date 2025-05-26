require "rails/engine"

module StompBase
  class Engine < ::Rails::Engine
    isolate_namespace StompBase
    
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.assets false
      g.helper true
    end

    # I18n設定
    config.before_configuration do
      I18n.load_path += Dir[Engine.root.join('config', 'locales', '*.yml')]
    end

    initializer "stomp_base.set_locale" do |app|
      # アプリケーション起動時にStompBaseの設定に基づいてロケールを設定
      app.config.after_initialize do
        I18n.default_locale = StompBase.locale
      end
    end
  end
end
