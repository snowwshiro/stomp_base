# frozen_string_literal: true

require "spec_helper"
require "rails"
require "stomp_base/engine"

RSpec.describe StompBase::Engine do
  describe ".should_serve_static_assets?" do
    context "when Rails application has asset pipeline" do
      let(:app_config) do
        double("app_config").tap do |config|
          allow(config).to receive(:assets).and_return(double("assets"))
          allow(config).to receive(:public_file_server).and_return(
            double("public_file_server", enabled: true)
          )
        end
      end

      it "returns false" do
        expect(described_class.should_serve_static_assets?(app_config)).to be false
      end
    end

    context "when Rails application is API-only without asset pipeline" do
      let(:app_config) do
        double("app_config").tap do |config|
          allow(config).to receive(:public_file_server).and_return(
            double("public_file_server", enabled: true)
          )
        end
      end

      before do
        # Simulate API-only mode where config.assets is not defined
        expect(app_config).not_to respond_to(:assets)
      end

      it "returns true when public file server is enabled" do
        expect(described_class.should_serve_static_assets?(app_config)).to be true
      end
    end

    context "when Rails application is API-only with public file server disabled" do
      let(:app_config) do
        double("app_config").tap do |config|
          allow(config).to receive(:public_file_server).and_return(
            double("public_file_server", enabled: false)
          )
        end
      end

      before do
        # Simulate API-only mode where config.assets is not defined
        expect(app_config).not_to respond_to(:assets)
      end

      it "returns false when public file server is disabled" do
        expect(described_class.should_serve_static_assets?(app_config)).to be false
      end
    end
  end
end