# Rails Demo API - StompBase

This is a minimal Rails API-only application designed to test and demonstrate StompBase engine functionality in API mode environments.

## Features

- **Rails API-only**: Configured with `config.api_only = true`
- **StompBase Integration**: Engine mounted at `/stomp_base`
- **CORS Support**: Cross-origin requests enabled for API consumption
- **JSON Responses**: All endpoints support JSON responses
- **API Authentication**: Demonstrates API key authentication patterns
- **Request Specs**: Comprehensive test coverage for API scenarios

## Structure

```
spec/rails_demo_api/
├── Gemfile                    # API-focused dependencies
├── Rakefile
├── config.ru
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb  # API base controller
│   │   └── api_controller.rb          # Root API info endpoint
│   └── models/                        # (empty, for future models)
├── config/
│   ├── application.rb         # Rails.application with api_only = true
│   ├── routes.rb             # StompBase::Engine mounted
│   ├── database.yml          # SQLite configuration
│   ├── environments/         # Development and test configs
│   └── initializers/
│       ├── stomp_base.rb     # StompBase configuration
│       └── cors.rb           # CORS configuration
└── spec/
    ├── rails_helper.rb
    ├── spec_helper.rb
    ├── requests/
    │   ├── api_spec.rb
    │   └── stomp_base/
    │       ├── dashboard_spec.rb      # Dashboard API tests
    │       ├── console_spec.rb        # Console API tests
    │       └── api_integration_spec.rb # API-specific integration tests
```

## Endpoints

### Root API
- `GET /` - API information and status
- `GET /up` - Health check endpoint

### StompBase Engine (mounted at `/stomp_base`)
- `GET /stomp_base` - Dashboard
- `GET /stomp_base/console` - Ruby console interface
- `POST /stomp_base/console/execute` - Execute Ruby code
- `GET /stomp_base/settings` - Configuration settings
- `PATCH /stomp_base/settings` - Update settings
- `GET /stomp_base/models` - Application models listing

## Running the Application

### Setup
```bash
cd spec/rails_demo_api
bundle install
rails db:create db:migrate
```

### Development Server
```bash
rails server -p 3001  # Different port to avoid conflicts
```

### Testing
```bash
# Run all specs
bundle exec rspec

# Run only StompBase specs
bundle exec rspec spec/requests/stomp_base/

# Run specific test file
bundle exec rspec spec/requests/stomp_base/dashboard_spec.rb
```

## API Usage Examples

### Basic API Information
```bash
curl http://localhost:3001/
```

### StompBase Dashboard (JSON)
```bash
curl -H "Accept: application/json" http://localhost:3001/stomp_base
```

### Execute Ruby Code via Console
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"code": "1 + 1"}' \
  http://localhost:3001/stomp_base/console/execute
```

### With API Key Authentication (when enabled)
```bash
curl -H "X-API-Key: your-api-key" \
     -H "Accept: application/json" \
     http://localhost:3001/stomp_base
```

## Configuration

### StompBase Configuration
The StompBase engine is configured in `config/initializers/stomp_base.rb`:

```ruby
StompBase.configure do |config|
  config.locale = :en
  
  # Enable API key authentication
  # config.enable_authentication(method: :api_key, keys: ["demo-api-key"])
end
```

### CORS Configuration
CORS is configured in `config/initializers/cors.rb` to allow cross-origin requests from any origin. In production, you should restrict this to specific domains.

## Testing Scenarios

The test suite covers:

- **JSON Response Handling**: Ensuring all endpoints properly return JSON when requested
- **CORS Support**: Cross-origin request handling
- **API Authentication**: Both unauthenticated and API key scenarios
- **Error Handling**: Proper JSON error responses
- **StompBase Integration**: All major StompBase endpoints
- **Console Functionality**: Ruby code execution via API

## Differences from Regular Rails Demo

Unlike the full Rails demo (`spec/rails_demo/`), this API demo:

- Uses `ActionController::API` instead of `ActionController::Base`
- Has no view layer (no ERB templates, assets, etc.)
- Includes CORS middleware for cross-origin requests
- Focuses on JSON responses and API patterns
- Has API-specific test scenarios
- Demonstrates headless StompBase usage

## Integration with StompBase

This demo validates that StompBase works correctly in Rails API-only mode by:

- Mounting the engine in an API-only application
- Testing all major endpoints for JSON response capability
- Validating authentication works in API contexts
- Ensuring CORS headers are properly set
- Testing console functionality via JSON requests