require 'spec_helper'

# Configuration class tests without Rails environment dependency
require_relative '../../lib/stomp_base/configuration'

RSpec.describe StompBase::Configuration do
  let(:config) { described_class.new }

  describe '#initialize' do
    it 'sets default values' do
      expect(config.locale).to eq(:en)
      expect(config.available_locales).to eq([:en, :ja])
      expect(config.authentication_enabled?).to be false
      expect(config.authentication_method).to eq(:basic_auth)
    end
  end

  describe '#locale=' do
    it 'accepts valid locales' do
      config.locale = :ja
      expect(config.locale).to eq(:ja)
    end

    it 'converts string to symbol' do
      config.locale = 'ja'
      expect(config.locale).to eq(:ja)
    end

    it 'raises error for invalid locale' do
      expect {
        config.locale = :fr
      }.to raise_error(ArgumentError, /Unsupported locale: fr/)
    end
  end

  describe '#enable_authentication' do
    context 'with basic auth' do
      it 'enables basic authentication' do
        config.enable_authentication(
          method: :basic_auth,
          username: 'admin',
          password: 'secret'
        )
        
        expect(config.authentication_enabled?).to be true
        expect(config.authentication_method).to eq(:basic_auth)
        expect(config.basic_auth_username).to eq('admin')
        expect(config.basic_auth_password).to eq('secret')
      end

      it 'raises error when username is missing' do
        expect {
          config.enable_authentication(
            method: :basic_auth,
            password: 'secret'
          )
        }.to raise_error(ArgumentError, 'Basic auth requires both username and password')
      end
    end

    context 'with API key auth' do
      it 'enables API key authentication' do
        config.enable_authentication(
          method: :api_key,
          keys: ['key1', 'key2']
        )
        
        expect(config.authentication_enabled?).to be true
        expect(config.authentication_method).to eq(:api_key)
        expect(config.valid_api_keys).to eq(['key1', 'key2'])
      end

      it 'accepts single key' do
        config.enable_authentication(
          method: :api_key,
          keys: 'single-key'
        )
        
        expect(config.valid_api_keys).to eq(['single-key'])
      end
    end

    context 'with custom auth' do
      it 'enables custom authentication' do
        authenticator = ->(request, params) { true }
        config.enable_authentication(
          method: :custom,
          authenticator: authenticator
        )
        
        expect(config.authentication_enabled?).to be true
        expect(config.authentication_method).to eq(:custom)
        expect(config.custom_authenticator).to eq(authenticator)
      end
    end
  end

  describe '#disable_authentication' do
    it 'disables authentication' do
      config.enable_authentication(
        method: :basic_auth,
        username: 'admin',
        password: 'secret'
      )
      
      expect(config.authentication_enabled?).to be true
      
      config.disable_authentication
      
      expect(config.authentication_enabled?).to be false
    end
  end
end
