# 🎛️ Stomp Base

A Rails engine that provides a browser-based admin interface and Rails console for your applications.

## Features

- 📊 **Dashboard**: Real-time Rails application statistics and system information
- 💻 **Browser Console**: Execute Ruby code directly in your Rails environment  
- 🎨 **Modern UI**: Clean, responsive interface
- 🌐 **Multi-language Support**: English and Japanese interface
- 🔧 **Easy Integration**: Simple gem installation and mounting process
- 🔐 **Built-in Authentication**: Simple authentication options (Basic Auth, API keys, Custom)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stomp_base'
```

Then, execute:

```
bundle install
```

## Usage

After installing the gem, you can mount the engine in your `routes.rb` file:

```ruby
Rails.application.routes.draw do
  mount StompBase::Engine => "/stomp_base"
end
```

### Language Configuration

You can configure the language in an initializer file (`config/initializers/stomp_base.rb`):

```ruby
# Set to Japanese
StompBase.configure do |config|
  config.locale = :ja
end

# Or set directly
StompBase.locale = :ja

# Default is English (:en)
StompBase.configure do |config|
  config.locale = :en
end
```

### Authentication Configuration

Stomp Base includes built-in authentication features that can be easily configured:

#### Basic Authentication

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.locale = :ja
  
  config.enable_authentication(
    method: :basic_auth,
    username: 'admin',
    password: 'your_secure_password'
  )
end
```

#### API Key Authentication

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.enable_authentication(
    method: :api_key,
    keys: ['your-api-key-1', 'your-api-key-2']
  )
end
```

#### Custom Authentication

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.enable_authentication(
    method: :custom,
    authenticator: ->(request, params) {
      # Your custom authentication logic
      request.headers['Authorization'] == 'Bearer your-token'
    }
  )
end
```

#### Disable Authentication

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.disable_authentication
end
```

For more detailed authentication configuration examples, see the **Authentication Details** section below.

```

Available locales:
- `:en` - English (default)
- `:ja` - Japanese (日本語)

### Accessing the Interface

- Dashboard: `/stomp_base/` or `/stomp_base/dashboard`
- Console: `/stomp_base/console`
- Settings: `/stomp_base/settings`

You can also change the language through the web interface by accessing the Settings page.

## Development

To contribute to Stomp Base, clone the repository and run the following commands:

```bash
bundle install
```

To run tests, use:

```bash
rspec
```

## API Reference

### Configuration Options

```ruby
StompBase.configure do |config|
  config.locale = :ja                    # Set interface language
  config.available_locales = [:en, :ja]  # Available language options (read-only)
  
  # Authentication options
  config.enable_authentication(          # Enable authentication
    method: :basic_auth,                 # :basic_auth, :api_key, or :custom
    username: 'admin',                   # For basic_auth
    password: 'password',                # For basic_auth
    keys: ['api-key'],                   # For api_key (array of valid keys)
    authenticator: -> { }                # For custom (callable object)
  )
  config.disable_authentication          # Disable authentication
end
```

### Authentication Helper Methods

```ruby
# Check if authentication is enabled
StompBase.authentication_enabled?    # => true or false

# Enable authentication
StompBase.enable_authentication(method: :basic_auth, username: 'admin', password: 'pass')

# Disable authentication
StompBase.disable_authentication
```

### Direct Configuration

```ruby
# Get current locale
StompBase.locale         # => :en

# Set locale directly
StompBase.locale = :ja   # Set to Japanese
StompBase.locale = :en   # Set to English (default)
```

### I18n Helper Methods

When included in controllers or views:

```ruby
include StompBase::I18nHelper

# Translate keys with automatic "stomp_base." prefix
t('dashboard.title')        # => "Stomp Base Dashboard" or "Stomp Base ダッシュボード"
t('console.placeholder')    # => "Enter Ruby code..." or "Ruby コードを入力してください..."

# Get available locales
available_locales          # => [:en, :ja]

# Get current locale
current_locale            # => :en or :ja

# Get locale display name
locale_name(:en)          # => "English"
locale_name(:ja)          # => "日本語"
```

### Session Management

The engine automatically saves the selected language to the user's session:

```ruby
# Language preference is stored in session[:stomp_base_locale]
# and persists across page reloads and browser sessions
```

## Translation Files

Translation files are located in `config/locales/`:

- `en.yml` - English translations
- `ja.yml` - Japanese translations

You can add more languages by creating additional YAML files and updating the configuration.

## Authentication Details

StompBase has built-in authentication features that can be easily enabled through configuration files without using database or session functionality.

### Authentication Methods

#### 1. Basic Authentication

The most basic authentication method. Set a username and password.

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.locale = :ja
  
  # Enable Basic Authentication
  config.enable_authentication(
    method: :basic_auth,
    username: 'admin',
    password: 'secret123'
  )
end
```

#### 2. API Key Authentication

API key-based authentication. Multiple keys can be configured.

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.locale = :ja
  
  # Enable API Key Authentication
  config.enable_authentication(
    method: :api_key,
    keys: ['your-api-key-1', 'your-api-key-2']
  )
end
```

API keys can be sent in the following ways:
- HTTP Header: `X-API-Key: your-api-key`
- URL Parameter: `?api_key=your-api-key`

#### 3. Custom Authentication

You can implement your own custom authentication logic.

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.locale = :ja
  
  # Enable Custom Authentication
  config.enable_authentication(
    method: :custom,
    authenticator: ->(request, params) {
      # Implement your custom authentication logic
      # Return true for authentication success, false for failure
      token = request.headers['Authorization']
      token == 'Bearer your-custom-token'
    }
  )
end
```

### Disabling Authentication

To disable authentication:

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.disable_authentication
end

# Or simply
StompBase.disable_authentication
```

### Skipping Authentication for Specific Actions

To skip authentication for specific controllers or actions:

```ruby
class MyController < StompBase::ApplicationController
  skip_before_action :authenticate_stomp_base, only: [:public_action]
  
  def public_action
    # Accessible without authentication
  end
  
  def private_action
    # Requires authentication
  end
end
```

### Environment-specific Configuration

Example of using different settings for production and development environments:

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.locale = :ja
  
  if Rails.env.production?
    # Strong authentication for production
    config.enable_authentication(
      method: :api_key,
      keys: [ENV['STOMP_BASE_API_KEY']]
    )
  elsif Rails.env.development?
    # Simple authentication for development
    config.enable_authentication(
      method: :basic_auth,
      username: 'dev',
      password: 'dev'
    )
  else
    # Disable authentication for test environment
    config.disable_authentication
  end
end
```

### Security Notes

- It is recommended to manage Basic Auth passwords and API keys using environment variables
- Use HTTPS (especially when using Basic Authentication)
- Update API keys regularly
- Be careful not to output authentication information to log files

## Implementation Summary

### Authentication Feature Implementation Details

The authentication feature is implemented with the following approach:

#### ✅ Implemented Features

1. **Simple Authentication**
   - Basic Authentication (username/password)
   - API Key Authentication (header or parameter)
   - Custom Authentication (custom logic)

2. **Configuration via initializer file**
   ```ruby
   # config/initializers/stomp_base.rb
   StompBase.configure do |config|
     config.enable_authentication(
       method: :basic_auth,
       username: 'admin',
       password: 'password'
     )
   end
   ```

3. **No database or session functionality**
   - Memory-based configuration management
   - Authentication information via HTTP headers or parameters
   - Simple implementation without persistence

#### 📁 Added Files

- `lib/stomp_base/authentication.rb` - Authentication feature implementation
- `lib/stomp_base/configuration.rb` - Added authentication configuration functionality
- `spec/controllers/stomp_base/authentication_spec.rb` - Controller tests
- `spec/lib/stomp_base/configuration_spec.rb` - Configuration class tests
- `spec/unit/configuration_spec.rb` - Unit tests

#### 🔧 Modified Files

- `lib/stomp_base.rb` - Authentication feature loading and helper method additions
- `app/controllers/stomp_base/application_controller.rb` - Authentication module integration
- `stomp_base.gemspec` - Added authentication feature description
- `Gemfile` - Added bigdecimal dependency

#### ✅ Verified Functionality

1. **Access without authentication**: Correctly rejected with 401 Unauthorized
2. **Correct authentication credentials**: Successfully accessed with 200 OK
3. **Incorrect authentication credentials**: Correctly rejected with 401 Unauthorized
4. **Demo application**: Working normally at localhost:3001

#### 🚀 Future Extension Possibilities

Authentication feature implementation is complete. The following extensions are possible if needed:
- Add authentication logging
- Rate limiting functionality
- Dynamic authentication configuration changes
- Addition of more authentication methods

## License

This project is licensed under the MIT License. See the LICENSE file for details.