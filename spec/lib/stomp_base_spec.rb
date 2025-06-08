# frozen_string_literal: true

require "spec_helper"
require "stomp_base"

RSpec.describe StompBase do
  describe ".configure" do
    it "yields the configuration" do
      expect { |b| described_class.configure(&b) }.to yield_with_args(StompBase::Configuration)
    end
  end

  describe ".configuration" do
    it "returns a Configuration instance" do
      expect(described_class.configuration).to be_a(StompBase::Configuration)
    end
  end
end
