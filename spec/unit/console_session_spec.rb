# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Console session state persistence" do
  let(:controller) { Object.new }
  
  before do
    controller.extend(Module.new do
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
    end)
  end
  
  describe "session binding management" do
    it "creates separate bindings for different sessions" do
      session1 = "session1"
      session2 = "session2"
      
      binding1 = controller.get_or_create_session_binding(session1)
      binding2 = controller.get_or_create_session_binding(session2)
      
      expect(binding1).not_to eq(binding2)
    end
    
    it "reuses the same binding for the same session" do
      session_id = "test_session"
      
      binding1 = controller.get_or_create_session_binding(session_id)
      binding2 = controller.get_or_create_session_binding(session_id)
      
      expect(binding1).to eq(binding2)
    end
    
    it "clears session binding when requested" do
      session_id = "test_session"
      
      original_binding = controller.get_or_create_session_binding(session_id)
      controller.clear_session_binding(session_id)
      new_binding = controller.get_or_create_session_binding(session_id)
      
      expect(new_binding).not_to eq(original_binding)
    end
  end
  
  describe "variable persistence" do
    it "maintains variables across commands in same session" do
      session_id = "persistence_test"
      
      binding = controller.get_or_create_session_binding(session_id)
      
      # First command: set a variable
      binding.eval("test_var = 'hello world'")
      
      # Second command: access the variable
      result = binding.eval("test_var")
      
      expect(result).to eq("hello world")
    end
    
    it "isolates variables between different sessions" do
      session1 = "session1"
      session2 = "session2"
      
      binding1 = controller.get_or_create_session_binding(session1)
      binding2 = controller.get_or_create_session_binding(session2)
      
      # Set variable in session1
      binding1.eval("session_var = 'session1_value'")
      
      # Try to access in session2 - should fail
      expect { binding2.eval("session_var") }.to raise_error(NameError)
    end
  end
end