# frozen_string_literal: true

require "spec_helper"
require "stomp_base/ip_authentication_service"

RSpec.describe StompBase::IPAuthenticationService do
  describe ".validate_ip" do
    context "with valid IPv4 addresses" do
      it "allows exact IP match" do
        allowed_ips = ["192.168.1.100"]
        expect(described_class.validate_ip("192.168.1.100", allowed_ips)).to be true
      end

      it "denies non-matching IP" do
        allowed_ips = ["192.168.1.100"]
        expect(described_class.validate_ip("192.168.1.101", allowed_ips)).to be false
      end

      it "allows IP within CIDR range" do
        allowed_ips = ["192.168.1.0/24"]
        expect(described_class.validate_ip("192.168.1.100", allowed_ips)).to be true
        expect(described_class.validate_ip("192.168.1.1", allowed_ips)).to be true
        expect(described_class.validate_ip("192.168.1.254", allowed_ips)).to be true
      end

      it "denies IP outside CIDR range" do
        allowed_ips = ["192.168.1.0/24"]
        expect(described_class.validate_ip("192.168.2.100", allowed_ips)).to be false
        expect(described_class.validate_ip("10.0.0.1", allowed_ips)).to be false
      end

      it "handles multiple allowed IPs/ranges" do
        allowed_ips = ["192.168.1.100", "10.0.0.0/16", "203.0.113.5"]
        
        expect(described_class.validate_ip("192.168.1.100", allowed_ips)).to be true
        expect(described_class.validate_ip("10.0.50.100", allowed_ips)).to be true
        expect(described_class.validate_ip("203.0.113.5", allowed_ips)).to be true
        expect(described_class.validate_ip("172.16.0.1", allowed_ips)).to be false
      end
    end

    context "with valid IPv6 addresses" do
      it "allows exact IPv6 match" do
        allowed_ips = ["2001:db8::1"]
        expect(described_class.validate_ip("2001:db8::1", allowed_ips)).to be true
      end

      it "denies non-matching IPv6" do
        allowed_ips = ["2001:db8::1"]
        expect(described_class.validate_ip("2001:db8::2", allowed_ips)).to be false
      end

      it "allows IPv6 within CIDR range" do
        allowed_ips = ["2001:db8::/32"]
        expect(described_class.validate_ip("2001:db8::1", allowed_ips)).to be true
        expect(described_class.validate_ip("2001:db8:1::1", allowed_ips)).to be true
      end

      it "denies IPv6 outside CIDR range" do
        allowed_ips = ["2001:db8::/32"]
        expect(described_class.validate_ip("2001:db9::1", allowed_ips)).to be false
      end
    end

    context "with edge cases" do
      it "returns false for nil IP address" do
        allowed_ips = ["192.168.1.100"]
        expect(described_class.validate_ip(nil, allowed_ips)).to be false
      end

      it "returns false for empty IP address" do
        allowed_ips = ["192.168.1.100"]
        expect(described_class.validate_ip("", allowed_ips)).to be false
      end

      it "returns false for nil allowed_ips" do
        expect(described_class.validate_ip("192.168.1.100", nil)).to be false
      end

      it "returns false for empty allowed_ips" do
        expect(described_class.validate_ip("192.168.1.100", [])).to be false
      end

      it "returns false for invalid IP address format" do
        allowed_ips = ["192.168.1.100"]
        expect(described_class.validate_ip("invalid-ip", allowed_ips)).to be false
        expect(described_class.validate_ip("999.999.999.999", allowed_ips)).to be false
      end

      it "returns false for invalid CIDR in allowed list" do
        allowed_ips = ["invalid-cidr/24"]
        expect(described_class.validate_ip("192.168.1.100", allowed_ips)).to be false
      end
    end
  end

  describe ".extract_client_ip" do
    let(:request) { double("request") }

    before do
      allow(request).to receive(:headers).and_return({})
      allow(request).to receive(:remote_ip).and_return("127.0.0.1")
    end

    it "uses X-Forwarded-For header when present" do
      allow(request).to receive(:headers).and_return({"X-Forwarded-For" => "203.0.113.100"})
      expect(described_class.extract_client_ip(request)).to eq("203.0.113.100")
    end

    it "handles multiple IPs in X-Forwarded-For (takes first)" do
      allow(request).to receive(:headers).and_return({"X-Forwarded-For" => "203.0.113.100, 192.168.1.1, 10.0.0.1"})
      expect(described_class.extract_client_ip(request)).to eq("203.0.113.100")
    end

    it "strips whitespace from X-Forwarded-For" do
      allow(request).to receive(:headers).and_return({"X-Forwarded-For" => "  203.0.113.100  "})
      expect(described_class.extract_client_ip(request)).to eq("203.0.113.100")
    end

    it "uses X-Real-IP header when X-Forwarded-For is not present" do
      allow(request).to receive(:headers).and_return({"X-Real-IP" => "203.0.113.200"})
      expect(described_class.extract_client_ip(request)).to eq("203.0.113.200")
    end

    it "strips whitespace from X-Real-IP" do
      allow(request).to receive(:headers).and_return({"X-Real-IP" => "  203.0.113.200  "})
      expect(described_class.extract_client_ip(request)).to eq("203.0.113.200")
    end

    it "falls back to remote_ip when no proxy headers present" do
      allow(request).to receive(:headers).and_return({})
      allow(request).to receive(:remote_ip).and_return("192.168.1.100")
      expect(described_class.extract_client_ip(request)).to eq("192.168.1.100")
    end
  end

  describe ".valid_ip_format?" do
    it "validates IPv4 addresses" do
      expect(described_class.valid_ip_format?("192.168.1.1")).to be true
      expect(described_class.valid_ip_format?("0.0.0.0")).to be true
      expect(described_class.valid_ip_format?("255.255.255.255")).to be true
    end

    it "validates IPv6 addresses" do
      expect(described_class.valid_ip_format?("2001:db8::1")).to be true
      expect(described_class.valid_ip_format?("::1")).to be true
      expect(described_class.valid_ip_format?("fe80::1")).to be true
    end

    it "rejects invalid IP formats" do
      expect(described_class.valid_ip_format?("invalid-ip")).to be false
      expect(described_class.valid_ip_format?("999.999.999.999")).to be false
      expect(described_class.valid_ip_format?("192.168.1")).to be false
      expect(described_class.valid_ip_format?(nil)).to be false
      expect(described_class.valid_ip_format?("")).to be false
    end
  end

  describe ".valid_cidr_format?" do
    it "validates IPv4 CIDR notation" do
      expect(described_class.valid_cidr_format?("192.168.1.0/24")).to be true
      expect(described_class.valid_cidr_format?("10.0.0.0/8")).to be true
      expect(described_class.valid_cidr_format?("172.16.0.0/16")).to be true
    end

    it "validates IPv6 CIDR notation" do
      expect(described_class.valid_cidr_format?("2001:db8::/32")).to be true
      expect(described_class.valid_cidr_format?("fe80::/64")).to be true
    end

    it "rejects invalid CIDR formats" do
      expect(described_class.valid_cidr_format?("192.168.1.1")).to be false  # no slash
      expect(described_class.valid_cidr_format?("192.168.1.0/")).to be false  # no prefix length
      expect(described_class.valid_cidr_format?("invalid/24")).to be false
      expect(described_class.valid_cidr_format?("192.168.1.0/35")).to be false  # invalid prefix for IPv4
      expect(described_class.valid_cidr_format?(nil)).to be false
      expect(described_class.valid_cidr_format?("")).to be false
    end
  end
end