# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Console Controller Terminal Interface" do
  let(:controller) { Object.new }
  
  before do
    # Mock the controller methods we're testing
    controller.extend(Module.new do
      def initialize
        @session_bindings = {}
      end
      
      def get_or_create_session_binding(session_id)
        @session_bindings ||= {}
        @session_bindings[session_id] ||= create_console_binding
      end

      def clear_session_binding(session_id)
        @session_bindings ||= {}
        @session_bindings.delete(session_id)
      end

      def create_console_binding
        Object.new.instance_eval { binding }
      end
      
      def execute_command_with_session(command, session_id)
        binding_context = get_or_create_session_binding(session_id)
        binding_context.eval(command)
      end
    end)
  end
  
  describe "terminal session management" do
    it "maintains variable state across multiple commands" do
      session_id = "test_session"
      
      # First command: define a variable
      controller.execute_command_with_session("test_var = 'hello'", session_id)
      
      # Second command: modify the variable
      controller.execute_command_with_session("test_var = test_var + ' world'", session_id)
      
      # Third command: access the variable
      result = controller.execute_command_with_session("test_var", session_id)
      
      expect(result).to eq("hello world")
    end
    
    it "maintains method definitions across commands" do
      session_id = "method_session"
      
      # Define a method
      controller.execute_command_with_session("def greet(name)\n  'Hello, ' + name\nend", session_id)
      
      # Call the method
      result = controller.execute_command_with_session("greet('Ruby')", session_id)
      
      expect(result).to eq("Hello, Ruby")
    end
    
    it "maintains class definitions across commands" do
      session_id = "class_session"
      
      # Define a class
      controller.execute_command_with_session("class TestClass\n  def initialize(value)\n    @value = value\n  end\n  \n  def get_value\n    @value\n  end\nend", session_id)
      
      # Use the class
      controller.execute_command_with_session("obj = TestClass.new('test')", session_id)
      result = controller.execute_command_with_session("obj.get_value", session_id)
      
      expect(result).to eq("test")
    end
    
    it "handles session restart properly" do
      session_id = "restart_session"
      
      # Set up some state
      controller.execute_command_with_session("persistent_var = 'should_be_cleared'", session_id)
      
      # Restart the session
      controller.clear_session_binding(session_id)
      
      # Try to access the variable - should fail
      expect { 
        controller.execute_command_with_session("persistent_var", session_id)
      }.to raise_error(NameError)
    end
    
    it "isolates different sessions properly" do
      session_a = "session_a"
      session_b = "session_b"
      
      # Set variables in different sessions
      controller.execute_command_with_session("session_var = 'A'", session_a)
      controller.execute_command_with_session("session_var = 'B'", session_b)
      
      # Check that each session has its own variable
      result_a = controller.execute_command_with_session("session_var", session_a)
      result_b = controller.execute_command_with_session("session_var", session_b)
      
      expect(result_a).to eq("A")
      expect(result_b).to eq("B")
    end
  end
end