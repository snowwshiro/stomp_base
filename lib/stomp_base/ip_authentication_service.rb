# frozen_string_literal: true

require "ipaddr"

module StompBase
  class IPAuthenticationService
    # Validate if the given IP address is allowed based on the configured IP ranges/addresses
    #
    # @param ip_address [String] The IP address to validate
    # @param allowed_ips [Array<String>] Array of allowed IP addresses and CIDR ranges
    # @return [Boolean] true if IP is allowed, false otherwise
    def self.validate_ip(ip_address, allowed_ips)
      return false if ip_address.nil? || ip_address.empty?
      return false if allowed_ips.nil? || allowed_ips.empty?

      begin
        client_ip = IPAddr.new(ip_address)
        
        allowed_ips.any? do |allowed_ip|
          allowed_range = IPAddr.new(allowed_ip)
          allowed_range.include?(client_ip)
        end
      rescue IPAddr::InvalidAddressError
        false
      end
    end

    # Extract the real client IP address from the request, considering proxy headers
    #
    # @param request [ActionDispatch::Request] The request object
    # @return [String, nil] The client IP address
    def self.extract_client_ip(request)
      # Check for forwarded headers first (for load balancers/proxies)
      forwarded_for = request.headers["X-Forwarded-For"]
      if forwarded_for
        # X-Forwarded-For can contain multiple IPs, take the first (original client)
        return forwarded_for.split(",").first&.strip
      end

      # Check for other common proxy headers
      real_ip = request.headers["X-Real-IP"]
      return real_ip.strip if real_ip

      # Fall back to remote IP
      request.remote_ip
    end

    # Validate IP address format (both IPv4 and IPv6)
    #
    # @param ip_address [String] The IP address to validate
    # @return [Boolean] true if valid IP format, false otherwise
    def self.valid_ip_format?(ip_address)
      return false if ip_address.nil? || ip_address.empty?
      
      IPAddr.new(ip_address)
      true
    rescue IPAddr::InvalidAddressError
      false
    end

    # Validate CIDR notation format
    #
    # @param cidr [String] The CIDR notation to validate
    # @return [Boolean] true if valid CIDR format, false otherwise
    def self.valid_cidr_format?(cidr)
      return false if cidr.nil? || cidr.empty?
      
      # CIDR must contain a slash
      return false unless cidr.include?("/")
      
      IPAddr.new(cidr)
      true
    rescue IPAddr::InvalidAddressError
      false
    end
  end
end