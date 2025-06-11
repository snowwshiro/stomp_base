# StompBase configuration for API demo
StompBase.configure do |config|
  # Configure locale
  config.locale = :en
  
  # Configure authentication (disabled by default for demo)
  # config.enable_authentication(method: :api_key, keys: ["demo-api-key"])
  
  # Allow console in production (disabled by default for security)
  # config.allow_console_in_production = false
end