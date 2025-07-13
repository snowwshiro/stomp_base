# frozen_string_literal: true

require "spec_helper"
require_relative "../app/controllers/stomp_base/console_controller"

RSpec.describe StompBase::ConsoleController::ConsoleBindingHelper do
  let(:helper) { described_class.new }

  describe "#initialize" do
    it "initializes with empty variables hash" do
      expect(helper.variables).to eq({})
    end
  end

  describe "variable assignment" do
    it "stores assigned variables" do
      helper.instance_eval { x = 42 }
      expect(helper.variables['x']).to eq(42)
    end

    it "allows retrieval of assigned variables" do
      helper.instance_eval { x = 42 }
      result = helper.instance_eval { x }
      expect(result).to eq(42)
    end

    it "handles string variables" do
      helper.instance_eval { name = "John" }
      expect(helper.variables['name']).to eq("John")
    end

    it "handles complex objects" do
      helper.instance_eval { arr = [1, 2, 3] }
      expect(helper.variables['arr']).to eq([1, 2, 3])
    end
  end

  describe "method_missing" do
    it "handles variable assignment via method_missing" do
      helper.send(:y=, 100)
      expect(helper.variables['y']).to eq(100)
    end

    it "handles variable retrieval via method_missing" do
      helper.send(:y=, 100)
      result = helper.send(:y)
      expect(result).to eq(100)
    end
  end

  describe "respond_to_missing?" do
    it "responds to assignment methods" do
      expect(helper.respond_to?(:test_var=)).to be true
    end

    it "responds to defined variables" do
      helper.send(:test_var=, "value")
      expect(helper.respond_to?(:test_var)).to be true
    end

    it "does not respond to undefined variables" do
      expect(helper.respond_to?(:undefined_var)).to be false
    end
  end

  describe "Rails helpers" do
    it "provides access to Rails app" do
      expect(helper.app).to eq(Rails.application)
    end

    it "provides access to application helpers" do
      expect(helper.helper).to respond_to(:content_tag) if defined?(ActionView)
    end
  end
end