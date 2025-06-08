# StompBase configuration
StompBase.configure do |config|
  # Configure locale
  config.locale = :ja
  
  # Configure authentication (disabled by default)
  # config.enable_authentication(method: :basic_auth, username: "admin", password: "password")
  
  # Allow console in production (disabled by default for security)
  # config.allow_console_in_production = false
end
