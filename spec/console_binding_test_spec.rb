# frozen_string_literal: true

require "spec_helper"

# Simple test implementation of ConsoleBindingHelper
class TestConsoleBindingHelper
  attr_reader :variables
  
  def initialize
    @variables = {}
  end
  
  def method_missing(method, *args, &block)
    method_name = method.to_s
    
    if method_name.end_with?('=')
      # Variable assignment
      var_name = method_name[0..-2]
      value = args.first
      @variables[var_name] = value
      instance_variable_set("@#{var_name}", value)
      value
    elsif @variables.key?(method_name)
      # Variable retrieval
      @variables[method_name]
    else
      super
    end
  end
  
  def respond_to_missing?(method, include_private = false)
    method_name = method.to_s
    method_name.end_with?('=') || @variables.key?(method_name) || super
  end
end

RSpec.describe TestConsoleBindingHelper do
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

  describe "variable persistence" do
    it "persists variables across evaluations" do
      helper.instance_eval { x = 42 }
      result = helper.instance_eval { x + 8 }
      expect(result).to eq(50)
    end

    it "handles chained assignments" do
      helper.instance_eval { x = y = 42 }
      expect(helper.variables['x']).to eq(42)
      expect(helper.variables['y']).to eq(42)
    end

    it "allows variable reassignment" do
      helper.instance_eval { x = 42 }
      helper.instance_eval { x = 84 }
      expect(helper.variables['x']).to eq(84)
    end
  end

  describe "error handling" do
    it "raises NameError for undefined variables" do
      expect { helper.instance_eval { undefined_var } }.to raise_error(NameError)
    end
  end
end