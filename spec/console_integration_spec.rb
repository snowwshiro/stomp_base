# frozen_string_literal: true

require "spec_helper"
require "json"

# Mock Rails components needed for testing
module Rails
  def self.application
    @application ||= Object.new
  end
  
  def self.env
    @env ||= "test"
  end
  
  def self.logger
    @logger ||= Object.new.tap do |logger|
      def logger.info(msg); end
      def logger.debug(msg); end
    end
  end
end

class ApplicationController
  def self.helpers
    @helpers ||= Object.new
  end
end

# Test the console controller functionality
RSpec.describe "Console Variable Assignment Integration" do
  let(:controller_class) do
    Class.new do
      def initialize
        @session = {}
      end
      
      def session
        @session
      end
      
      def execute_command(command)
        initialize_console_session
        
        if command.strip == 'vars'
          render_vars_command
        else
          execute_in_rails_console(command)
        end
      end
      
      private
      
      def execute_in_rails_console(command)
        binding_context = console_session_binding
        
        result = binding_context.eval(command)
        format_result(result)
      end

      def console_session_binding
        unless session[:console_binding]
          helper = ConsoleBindingHelper.new
          session[:console_binding] = helper.create_persistent_binding
        end
        session[:console_binding]
      end

      def initialize_console_session
        unless session[:console_binding]
          helper = ConsoleBindingHelper.new
          session[:console_binding] = helper.create_persistent_binding
        end
      end

      def render_vars_command
        binding_context = console_session_binding
        variables = extract_variables_from_binding(binding_context)
        format_variables(variables)
      end

      def extract_variables_from_binding(binding_context)
        vars = {}
        
        binding_context.local_variables.each do |var|
          var_name = var.to_s
          next if var_name.start_with?('_')
          
          vars[var_name] = binding_context.local_variable_get(var)
        end
        
        vars
      end

      def format_variables(variables)
        return "No variables defined." if variables.empty?
        
        output = "Variables:\n"
        variables.each do |name, value|
          output += "  #{name}: #{value.inspect}\n"
        end
        output.chomp
      end

      def format_result(result)
        result.inspect
      end
    end
  end

  let(:helper_class) do
    Class.new do
      def initialize
        @persistent_binding = nil
      end
      
      def create_persistent_binding
        return @persistent_binding if @persistent_binding
        
        @persistent_binding = binding
        
        @persistent_binding.eval("
          def app
            Rails.application
          end

          def helper
            ApplicationController.helpers
          end

          def reload!
            'reloaded!'
          end
        ")
        
        @persistent_binding
      end
    end
  end

  # Define the classes in the test scope
  before do
    stub_const('ConsoleBindingHelper', helper_class)
  end

  let(:controller) { controller_class.new }

  describe "variable assignment and persistence" do
    it "assigns and retrieves simple variables" do
      result = controller.execute_command("x = 42")
      expect(result).to eq("42")
      
      result = controller.execute_command("x")
      expect(result).to eq("42")
    end

    it "handles string variables" do
      result = controller.execute_command("name = 'John'")
      expect(result).to eq("\"John\"")
      
      result = controller.execute_command("name")
      expect(result).to eq("\"John\"")
    end

    it "handles array variables" do
      result = controller.execute_command("arr = [1, 2, 3]")
      expect(result).to eq("[1, 2, 3]")
      
      result = controller.execute_command("arr.sum")
      expect(result).to eq("6")
    end

    it "persists variables across multiple commands" do
      controller.execute_command("x = 10")
      controller.execute_command("y = 20")
      
      result = controller.execute_command("x + y")
      expect(result).to eq("30")
    end

    it "allows variable reassignment" do
      controller.execute_command("x = 42")
      result = controller.execute_command("x = 84")
      expect(result).to eq("84")
      
      result = controller.execute_command("x")
      expect(result).to eq("84")
    end

    it "handles complex expressions with variables" do
      controller.execute_command("base = 10")
      controller.execute_command("multiplier = 3")
      
      result = controller.execute_command("result = base * multiplier + 5")
      expect(result).to eq("35")
    end
  end

  describe "vars command" do
    it "shows no variables when none are defined" do
      result = controller.execute_command("vars")
      expect(result).to eq("No variables defined.")
    end

    it "lists all defined variables" do
      controller.execute_command("x = 42")
      controller.execute_command("name = 'John'")
      
      result = controller.execute_command("vars")
      expect(result).to include("Variables:")
      expect(result).to include("x: 42")
      expect(result).to include("name: \"John\"")
    end

    it "updates variable list after new assignments" do
      controller.execute_command("x = 42")
      
      result = controller.execute_command("vars")
      expect(result).to include("x: 42")
      
      controller.execute_command("y = 'test'")
      
      result = controller.execute_command("vars")
      expect(result).to include("x: 42")
      expect(result).to include("y: \"test\"")
    end

    it "reflects variable changes" do
      controller.execute_command("x = 42")
      controller.execute_command("x = 84")
      
      result = controller.execute_command("vars")
      expect(result).to include("x: 84")
      expect(result).not_to include("x: 42")
    end
  end

  describe "Rails integration" do
    it "provides access to Rails helpers in binding" do
      result = controller.execute_command("app")
      expect(result).to include("Object")
    end

    it "provides access to reload method" do
      result = controller.execute_command("reload!")
      expect(result).to eq("\"reloaded!\"")
    end

    it "allows assignment of Rails objects to variables" do
      controller.execute_command("my_app = app")
      
      result = controller.execute_command("vars")
      expect(result).to include("my_app:")
    end
  end

  describe "error handling" do
    it "raises appropriate errors for undefined variables" do
      expect { controller.execute_command("undefined_var") }.to raise_error(NameError)
    end

    it "handles syntax errors" do
      expect { controller.execute_command("invalid syntax =") }.to raise_error(SyntaxError)
    end
  end

  describe "session persistence" do
    it "maintains different variable scopes for different controller instances" do
      controller1 = controller_class.new
      controller2 = controller_class.new
      
      controller1.execute_command("x = 42")
      controller2.execute_command("x = 84")
      
      result1 = controller1.execute_command("x")
      result2 = controller2.execute_command("x")
      
      expect(result1).to eq("42")
      expect(result2).to eq("84")
    end
  end
end