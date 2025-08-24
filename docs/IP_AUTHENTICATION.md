# IP-Based Authentication

StompBase supports IP-based authentication that allows you to restrict access to your application based on client IP addresses and IP ranges.

## Basic Usage

Configure IP authentication by specifying allowed IP addresses and/or CIDR ranges:

```ruby
StompBase.configure do |config|
  config.enable_authentication(
    method: :ip_auth,
    allowed_ips: %w[
      192.168.1.0/24    # Allow entire office network
      10.0.0.100        # Allow specific VPN gateway
      203.0.113.5       # Allow specific remote office
    ]
  )
end
```

## Features

### IP Address Support
- **IPv4 addresses**: `192.168.1.100`, `10.0.0.1`
- **IPv6 addresses**: `2001:db8::1`, `fe80::1`
- **CIDR notation**: `192.168.1.0/24`, `10.0.0.0/8`, `2001:db8::/32`

### Proxy Support
The system automatically handles common proxy scenarios:
- **X-Forwarded-For**: For load balancers and reverse proxies
- **X-Real-IP**: For nginx and similar proxies
- **REMOTE_ADDR**: Fallback for direct connections

### Security Features
- Validates IP addresses and CIDR ranges at configuration time
- Handles invalid IP formats gracefully
- Provides detailed error messages including the client's IP address
- Thread-safe for concurrent requests

## Configuration Examples

### Office Network Only
```ruby
StompBase.configure do |config|
  config.enable_authentication(
    method: :ip_auth,
    allowed_ips: ["192.168.1.0/24"]
  )
end
```

### Multiple Networks
```ruby
StompBase.configure do |config|
  config.enable_authentication(
    method: :ip_auth,
    allowed_ips: %w[
      192.168.1.0/24    # Main office
      192.168.2.0/24    # Branch office
      10.0.0.0/16       # VPN network
    ]
  )
end
```

### IPv6 Support
```ruby
StompBase.configure do |config|
  config.enable_authentication(
    method: :ip_auth,
    allowed_ips: %w[
      192.168.1.0/24    # IPv4 office network
      2001:db8::/32     # IPv6 network
      fe80::1           # Specific IPv6 address
    ]
  )
end
```

## Error Handling

When access is denied, users receive clear error messages:

### JSON Response (API requests)
```json
{
  "error": "Access restricted. Your IP address (172.16.0.1) is not authorized to access this application.",
  "client_ip": "172.16.0.1"
}
```

### HTML Response (Browser requests)
```
Access restricted. Your IP address (172.16.0.1) is not authorized to access this application.
```

## Integration with Other Authentication Methods

IP authentication can work alongside other authentication methods by using the custom authentication approach:

```ruby
StompBase.configure do |config|
  config.enable_authentication(
    method: :custom,
    authenticator: ->(request, params) {
      # First check IP address
      client_ip = StompBase::IPAuthenticationService.extract_client_ip(request)
      allowed_ips = %w[192.168.1.0/24 10.0.0.100]
      
      ip_valid = StompBase::IPAuthenticationService.validate_ip(client_ip, allowed_ips)
      return false unless ip_valid
      
      # Then check API key or other authentication
      api_key = request.headers["X-API-Key"]
      %w[key1 key2].include?(api_key)
    }
  )
end
```

## Validation Utilities

The IP authentication service provides utility methods for validation:

```ruby
# Validate IP address format
StompBase::IPAuthenticationService.valid_ip_format?("192.168.1.1")  # => true
StompBase::IPAuthenticationService.valid_ip_format?("invalid-ip")    # => false

# Validate CIDR notation
StompBase::IPAuthenticationService.valid_cidr_format?("192.168.1.0/24")  # => true
StompBase::IPAuthenticationService.valid_cidr_format?("192.168.1.1")     # => false

# Extract client IP from request
client_ip = StompBase::IPAuthenticationService.extract_client_ip(request)

# Validate specific IP against allowed list
allowed = StompBase::IPAuthenticationService.validate_ip("192.168.1.100", ["192.168.1.0/24"])
```

## Security Considerations

1. **Proxy Configuration**: Ensure your load balancer or reverse proxy correctly sets the `X-Forwarded-For` or `X-Real-IP` headers.

2. **Network Changes**: Remember to update allowed IP ranges when network infrastructure changes.

3. **Emergency Access**: Consider implementing an emergency bypass mechanism for administrators.

4. **Logging**: Enable request logging to monitor IP authentication attempts.

5. **Rate Limiting**: Consider implementing rate limiting to prevent brute force attacks.

## Testing

Run the demo script to test IP authentication functionality:

```bash
ruby examples/ip_authentication_demo.rb
```

This script demonstrates:
- IP validation with CIDR ranges
- IPv4 and IPv6 support
- Error handling for invalid IPs
- Format validation utilities