# frozen_string_literal: true

require "spec_helper"
require_relative "../app/controllers/stomp_base/console_controller"

RSpec.describe "Console Variable Assignment" do
  let(:controller) { StompBase::ConsoleController.new }
  let(:helper) { StompBase::ConsoleController::ConsoleBindingHelper.new }

  before do
    # Mock Rails logger to avoid errors
    allow(Rails).to receive(:logger).and_return(double(info: nil, debug: nil))
  end

  describe "variable assignment detection" do
    it "detects simple assignment" do
      expect(helper.instance_eval { x = 42 }).to eq(42)
      expect(helper.variables['x']).to eq(42)
    end

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

    it "handles complex expressions" do
      helper.instance_eval { result = 2 * 3 + 4 }
      expect(helper.variables['result']).to eq(10)
    end
  end

  describe "variable retrieval" do
    before do
      helper.instance_eval { x = 42 }
      helper.instance_eval { name = "John" }
    end

    it "retrieves numeric variables" do
      result = helper.instance_eval { x }
      expect(result).to eq(42)
    end

    it "retrieves string variables" do
      result = helper.instance_eval { name }
      expect(result).to eq("John")
    end

    it "allows variables to be used in expressions" do
      result = helper.instance_eval { x * 2 }
      expect(result).to eq(84)
    end
  end

  describe "variable storage" do
    it "stores variables in the variables hash" do
      helper.instance_eval { test_var = "test_value" }
      expect(helper.variables).to include('test_var' => "test_value")
    end

    it "maintains variable count" do
      helper.instance_eval { var1 = 1 }
      helper.instance_eval { var2 = 2 }
      expect(helper.variables.size).to eq(2)
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

    it "handles syntax errors gracefully" do
      expect { helper.instance_eval { "invalid syntax =" } }.to raise_error(SyntaxError)
    end
  end

  describe "integration with Rails helpers" do
    it "provides access to Rails application" do
      result = helper.instance_eval { app }
      expect(result).to eq(Rails.application)
    end

    it "allows assignment of Rails-related variables" do
      helper.instance_eval { my_app = app }
      expect(helper.variables['my_app']).to eq(Rails.application)
    end
  end
end