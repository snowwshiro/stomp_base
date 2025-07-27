# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Console Controller Terminal Interface" do
  let(:controller) { Object.new }

  before do
    # Initialize session storage using global variables for testing
    $test_terminal_session_bindings = {}
    $test_terminal_session_mutex = Mutex.new
    $test_terminal_session_timestamps = {}

    # Mock the controller methods we're testing
    controller.extend(Module.new do
      def get_or_create_session_binding(session_id)
        $test_terminal_session_mutex.synchronize do
          # Clean up old sessions (older than 30 minutes)
          cleanup_old_sessions

          # Create or retrieve session binding
          unless $test_terminal_session_bindings[session_id]
            $test_terminal_session_bindings[session_id] = create_console_binding
            $test_terminal_session_timestamps[session_id] = Time.zone.now
          end

          # Update timestamp
          $test_terminal_session_timestamps[session_id] = Time.zone.now
          $test_terminal_session_bindings[session_id]
        end
      end

      def clear_session_binding(session_id)
        $test_terminal_session_mutex.synchronize do
          $test_terminal_session_bindings.delete(session_id)
          $test_terminal_session_timestamps.delete(session_id)
        end
      end

      def create_console_binding
        Object.new.instance_eval { binding }
      end

      def execute_command_with_session(command, session_id)
        binding_context = get_or_create_session_binding(session_id)
        binding_context.eval(command)
      end

      def cleanup_old_sessions
        current_time = Time.zone.now
        expired_sessions = $test_terminal_session_timestamps.select do |_session_id, timestamp|
          current_time - timestamp > 1800 # 30 minutes in seconds
        end

        expired_sessions.each_key do |session_id|
          $test_terminal_session_bindings.delete(session_id)
          $test_terminal_session_timestamps.delete(session_id)
        end
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
      expect do
        controller.execute_command_with_session("persistent_var", session_id)
      end.to raise_error(NameError)
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

    it "persists variables across multiple request cycles" do
      session_id = "persistent_session"

      # Simulate first request - set a variable
      controller.execute_command_with_session("persistent_var = 'value_from_first_request'", session_id)

      # Simulate second request (new controller instance)
      controller2 = Object.new
      controller2.extend(Module.new do
        def get_or_create_session_binding(session_id)
          $test_terminal_session_mutex.synchronize do
            # Clean up old sessions (older than 30 minutes)
            cleanup_old_sessions

            # Create or retrieve session binding
            unless $test_terminal_session_bindings[session_id]
              $test_terminal_session_bindings[session_id] = create_console_binding
              $test_terminal_session_timestamps[session_id] = Time.zone.now
            end

            # Update timestamp
            $test_terminal_session_timestamps[session_id] = Time.zone.now
            $test_terminal_session_bindings[session_id]
          end
        end

        def create_console_binding
          Object.new.instance_eval { binding }
        end

        def execute_command_with_session(command, session_id)
          binding_context = get_or_create_session_binding(session_id)
          binding_context.eval(command)
        end

        def cleanup_old_sessions
          current_time = Time.zone.now
          expired_sessions = $test_terminal_session_timestamps.select do |_session_id, timestamp|
            current_time - timestamp > 1800 # 30 minutes in seconds
          end

          expired_sessions.each_key do |session_id|
            $test_terminal_session_bindings.delete(session_id)
            $test_terminal_session_timestamps.delete(session_id)
          end
        end
      end)

      # Variable should persist
      result = controller2.execute_command_with_session("persistent_var", session_id)
      expect(result).to eq("value_from_first_request")
    end

    it "maintains complex state across commands" do
      session_id = "complex_state_session"

      # Create an array and modify it across multiple commands
      controller.execute_command_with_session("my_array = [1, 2, 3]", session_id)
      controller.execute_command_with_session("my_array << 4", session_id)
      controller.execute_command_with_session("my_array.map!(&:to_s)", session_id)

      result = controller.execute_command_with_session("my_array", session_id)
      expect(result).to eq(%w[1 2 3 4])
    end
  end
end
