# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Console session state persistence" do
  let(:controller) { Object.new }

  before do
    # Initialize session storage using global variables for testing
    $test_session_bindings = {}
    $test_session_mutex = Mutex.new
    $test_session_timestamps = {}

    controller.extend(Module.new do
      def get_or_create_session_binding(session_id)
        $test_session_mutex.synchronize do
          # Clean up old sessions (older than 30 minutes)
          cleanup_old_sessions

          # Create or retrieve session binding
          unless $test_session_bindings[session_id]
            $test_session_bindings[session_id] = create_console_binding
            $test_session_timestamps[session_id] = Time.now
          end

          # Update timestamp
          $test_session_timestamps[session_id] = Time.now
          $test_session_bindings[session_id]
        end
      end

      def clear_session_binding(session_id)
        $test_session_mutex.synchronize do
          $test_session_bindings.delete(session_id)
          $test_session_timestamps.delete(session_id)
        end
      end

      def create_console_binding
        Object.new.instance_eval { binding }
      end

      def cleanup_old_sessions
        current_time = Time.now
        expired_sessions = $test_session_timestamps.select do |_session_id, timestamp|
          current_time - timestamp > 1800 # 30 minutes in seconds
        end

        expired_sessions.each_key do |session_id|
          $test_session_bindings.delete(session_id)
          $test_session_timestamps.delete(session_id)
        end
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

      # Set variable in session2
      binding2.eval("session_var = 'session2_value'")

      # Check that sessions are isolated
      result1 = binding1.eval("session_var")
      result2 = binding2.eval("session_var")

      expect(result1).to eq("session1_value")
      expect(result2).to eq("session2_value")
    end

    it "persists variables across multiple request cycles" do
      session_id = "persistent_session"

      # Simulate first request
      binding1 = controller.get_or_create_session_binding(session_id)
      binding1.eval("persistent_var = 'first_value'")

      # Simulate second request (new controller instance)
      controller2 = Object.new
      controller2.extend(Module.new do
        def get_or_create_session_binding(session_id)
          $test_session_mutex.synchronize do
            # Clean up old sessions (older than 30 minutes)
            cleanup_old_sessions

            # Create or retrieve session binding
            unless $test_session_bindings[session_id]
              $test_session_bindings[session_id] = create_console_binding
              $test_session_timestamps[session_id] = Time.now
            end

            # Update timestamp
            $test_session_timestamps[session_id] = Time.now
            $test_session_bindings[session_id]
          end
        end

        def create_console_binding
          Object.new.instance_eval { binding }
        end

        def cleanup_old_sessions
          current_time = Time.now
          expired_sessions = $test_session_timestamps.select do |_session_id, timestamp|
            current_time - timestamp > 1800 # 30 minutes in seconds
          end

          expired_sessions.each_key do |session_id|
            $test_session_bindings.delete(session_id)
            $test_session_timestamps.delete(session_id)
          end
        end
      end)

      binding2 = controller2.get_or_create_session_binding(session_id)

      # Variable should persist
      result = binding2.eval("persistent_var")
      expect(result).to eq("first_value")
    end

    it "updates session timestamp on access" do
      session_id = "timestamp_session"

      # First access
      controller.get_or_create_session_binding(session_id)
      first_timestamp = $test_session_timestamps[session_id]

      # Wait a bit and access again
      sleep(0.1)
      controller.get_or_create_session_binding(session_id)
      second_timestamp = $test_session_timestamps[session_id]

      expect(second_timestamp).to be > first_timestamp
    end
  end
end
