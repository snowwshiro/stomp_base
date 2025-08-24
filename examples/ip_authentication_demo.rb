#!/usr/bin/env ruby
# frozen_string_literal: true

# Demo script to show IP-based authentication functionality
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "stomp_base"

puts "=== StompBase IP Authentication Demo ==="
puts

# Example 1: Configure IP authentication
puts "1. Configuring IP authentication..."
StompBase.configure do |config|
  config.enable_authentication(
    method: :ip_auth,
    allowed_ips: %w[192.168.1.0/24 10.0.0.100 203.0.113.5]
  )
end

puts "   Enabled: #{StompBase.authentication_enabled?}"
puts "   Method: #{StompBase.configuration.authentication_method}"
puts "   Allowed IPs: #{StompBase.configuration.allowed_ips.join(', ')}"
puts

# Example 2: Test IP validation
puts "2. Testing IP validation..."

test_cases = [
  { ip: "192.168.1.50", expected: true, description: "IP within CIDR range" },
  { ip: "10.0.0.100", expected: true, description: "Exact IP match" },
  { ip: "203.0.113.5", expected: true, description: "Another exact IP match" },
  { ip: "172.16.0.1", expected: false, description: "IP not in allowed list" },
  { ip: "192.168.2.50", expected: false, description: "IP outside CIDR range" },
  { ip: "invalid-ip", expected: false, description: "Invalid IP format" }
]

test_cases.each do |test_case|
  result = StompBase::IPAuthenticationService.validate_ip(
    test_case[:ip], 
    StompBase.configuration.allowed_ips
  )
  status = result == test_case[:expected] ? "✓ PASS" : "✗ FAIL"
  puts "   #{status}: #{test_case[:ip]} - #{test_case[:description]}"
end
puts

# Example 3: Test IPv6 support
puts "3. Testing IPv6 support..."
StompBase.configure do |config|
  config.enable_authentication(
    method: :ip_auth,
    allowed_ips: %w[2001:db8::/32 fe80::1]
  )
end

ipv6_test_cases = [
  { ip: "2001:db8::1", expected: true, description: "IPv6 within CIDR range" },
  { ip: "fe80::1", expected: true, description: "Exact IPv6 match" },
  { ip: "2001:db9::1", expected: false, description: "IPv6 outside CIDR range" }
]

ipv6_test_cases.each do |test_case|
  result = StompBase::IPAuthenticationService.validate_ip(
    test_case[:ip], 
    StompBase.configuration.allowed_ips
  )
  status = result == test_case[:expected] ? "✓ PASS" : "✗ FAIL"
  puts "   #{status}: #{test_case[:ip]} - #{test_case[:description]}"
end
puts

# Example 4: Test IP format validation
puts "4. Testing IP format validation..."

format_test_cases = [
  { ip: "192.168.1.1", expected: true, description: "Valid IPv4" },
  { ip: "2001:db8::1", expected: true, description: "Valid IPv6" },
  { ip: "invalid-ip", expected: false, description: "Invalid IP" },
  { ip: "999.999.999.999", expected: false, description: "Invalid IPv4" }
]

format_test_cases.each do |test_case|
  result = StompBase::IPAuthenticationService.valid_ip_format?(test_case[:ip])
  status = result == test_case[:expected] ? "✓ PASS" : "✗ FAIL"
  puts "   #{status}: #{test_case[:ip]} - #{test_case[:description]}"
end
puts

# Example 5: Test CIDR validation
puts "5. Testing CIDR format validation..."

cidr_test_cases = [
  { cidr: "192.168.1.0/24", expected: true, description: "Valid IPv4 CIDR" },
  { cidr: "2001:db8::/32", expected: true, description: "Valid IPv6 CIDR" },
  { cidr: "192.168.1.1", expected: false, description: "IP without CIDR" },
  { cidr: "invalid/24", expected: false, description: "Invalid CIDR" }
]

cidr_test_cases.each do |test_case|
  result = StompBase::IPAuthenticationService.valid_cidr_format?(test_case[:cidr])
  status = result == test_case[:expected] ? "✓ PASS" : "✗ FAIL"
  puts "   #{status}: #{test_case[:cidr]} - #{test_case[:description]}"
end
puts

puts "=== Demo Complete ==="
puts
puts "Usage in Rails application:"
puts
puts "StompBase.configure do |config|"
puts "  config.enable_authentication("
puts "    method: :ip_auth,"
puts "    allowed_ips: %w[192.168.1.0/24 10.0.0.100]"
puts "  )"
puts "end"
puts
puts "This will restrict access to only IPs in the 192.168.1.0/24 range"
puts "or the exact IP 10.0.0.100."