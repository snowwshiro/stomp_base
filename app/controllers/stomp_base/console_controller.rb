# frozen_string_literal: true

module StompBase
  class ConsoleController < StompBase::ApplicationController
    DANGEROUS_PATTERNS = [
      /system\s*\(/i,           # System calls
      /`/,                      # Backticks
      /%x\{/,                   # %x{} command execution
      /File\.(delete|unlink)/i, # File deletion
      /FileUtils\.(rm|remove)/i, # File removal
      /Dir\.(delete|rmdir)/i, # Directory removal
      /ActiveRecord.*delete_all/i, # Mass deletion
      /ActiveRecord.*destroy_all/i, # Mass destruction
      /drop_table/i,            # Table dropping
      /exit/i,                  # Exit commands
      /quit/i,                  # Quit commands
      /abort/i,                 # Abort commands
      /fork/i,                  # Process forking
      /spawn/i,                 # Process spawning
      /eval\s*\(/i,             # eval() calls (unless safe)
      /instance_eval/i,         # instance_eval calls
      /class_eval/i,            # class_eval calls
      /module_eval/i,           # module_eval calls
      /define_method/i,         # Dynamic method definition
      /remove_method/i,         # Method removal
      /undef_method/i,          # Method undefinition
      /const_missing/i,         # Constant manipulation
      /autoload/i,              # Autoload manipulation
      /load\s*\(/i,             # File loading
      /require\s*\(/i,          # File requiring (with some exceptions)
      /Rails\.application\.secrets/i, # Secret access
      /ENV\[.*SECRET/i # Environment secret access
    ].freeze
    
    # Disable Rails default layout to use LayoutComponent
    layout false

    # Disabled in production environment for security reasons
    before_action :ensure_not_production, only: %i[index execute]
    before_action :initialize_console_session, only: %i[execute]

    def index
      @console_component = StompBase::Pages::ConsoleComponent.new
    end

    def execute
      command = params[:command]&.strip
      return render_error(I18n.t("stomp_base.console.error")) if command.blank?

      process_console_command(command)
    rescue StandardError => e
      handle_execution_error(e)
    end

    def process_console_command(command)
      Rails.logger.info "StompBase Console Command: #{command}"
      return render_dangerous_command_error if dangerous_command?(command)

      # Handle special commands
      if command.strip == 'vars'
        return render_vars_command
      end

      result = execute_in_rails_console(command)
      render_success(result)
    end

    def handle_execution_error(error)
      Rails.logger.error "StompBase Console Error: #{error.message}"
      render_error(error.message)
    end

    private

    def render_error(message)
      render json: { success: false, error: message, result: nil }
    end

    def render_success(result)
      render json: { success: true, result: result.to_s, error: false }
    end

    def render_dangerous_command_error
      render json: {
        success: false,
        error: "Dangerous command detected. Execution denied."
      }
    end

    def ensure_not_production
      return unless Rails.env.production? && !StompBase.configuration.allow_console_in_production

      redirect_to stomp_base.root_path, alert: t("console.production_disabled")
    end

    def dangerous_command?(command)
      DANGEROUS_PATTERNS.any? { |pattern| command.match?(pattern) }
    end

    def execute_in_rails_console(command)
      # Evaluate command in secure execution environment
      # with variable persistence
      binding_context = console_session_binding
      
      # Set timeout (10 seconds)
      result = Timeout.timeout(10) do
        binding_context.eval(command)
      end

      # Return result in user-friendly format
      format_result(result)
    end

    def console_session_binding
      # Create or retrieve the persistent binding for this session
      unless session[:console_binding]
        helper = ConsoleBindingHelper.new
        session[:console_binding] = helper.create_persistent_binding
      end
      session[:console_binding]
    end

    def initialize_console_session
      # Initialize console session if not exists
      unless session[:console_binding]
        helper = ConsoleBindingHelper.new
        session[:console_binding] = helper.create_persistent_binding
      end
    end

    def render_vars_command
      binding_context = console_session_binding
      variables = extract_variables_from_binding(binding_context)
      vars_output = format_variables(variables)
      render_success(vars_output)
    end

    def extract_variables_from_binding(binding_context)
      vars = {}
      
      # Get local variables from the binding
      begin
        binding_context.local_variables.each do |var|
          var_name = var.to_s
          # Skip internal variables and method-like variables
          next if var_name.start_with?('_') || 
                  ['persistent_binding', 'result1', 'result2', 'result3', 'variables', 'result7'].include?(var_name)
          
          vars[var_name] = binding_context.local_variable_get(var)
        end
      rescue => e
        Rails.logger.debug "Error extracting variables: #{e.message}"
      end
      
      vars
    end

    def format_variables(variables)
      return "No variables defined." if variables.empty?
      
      output = "Variables:\n"
      variables.each do |name, value|
        formatted_value = format_result(value)
        output += "  #{name}: #{formatted_value}\n"
      end
      output.chomp
    end

    # Helper class for console binding with variable persistence
    class ConsoleBindingHelper
      def initialize
        @persistent_binding = nil
      end
      
      def create_persistent_binding
        return @persistent_binding if @persistent_binding
        
        # Create a new binding context with Rails helpers
        @persistent_binding = binding
        
        # Add Rails helpers to the binding context
        @persistent_binding.eval("
          def app
            Rails.application
          end

          def helper
            ApplicationController.helpers
          end

          def reload!
            Rails.application.reloader.reload!
          end
        ")
        
        @persistent_binding
      end
      
      def app
        Rails.application
      end

      def helper
        ApplicationController.helpers
      end

      def reload!
        Rails.application.reloader.reload!
      end
    end

    def define_console_helpers
      # This method is not used in the refactored approach
    end

    def format_result(result)
      return format_simple_result(result) if simple_result?(result)
      return format_collection_result(result) if collection_result?(result)
      return format_time_result(result) if time_result?(result)

      format_object_result(result)
    end

    def simple_result?(result)
      result.is_a?(NilClass) || result.is_a?(TrueClass) || result.is_a?(FalseClass) ||
        result.is_a?(Numeric) || result.is_a?(String) || result.is_a?(Symbol)
    end

    def collection_result?(result)
      result.is_a?(Array) || result.is_a?(ActiveRecord::Relation) ||
        result.is_a?(ActiveRecord::Base) || result.is_a?(Hash)
    end

    def time_result?(result)
      result.is_a?(Time) || result.is_a?(DateTime) || result.is_a?(Date)
    end

    def format_simple_result(result)
      case result
      when NilClass, TrueClass, FalseClass
        result.to_s
      else
        result.inspect
      end
    end

    def format_collection_result(result)
      case result
      when Array
        format_array_result(result)
      when ActiveRecord::Relation
        format_relation_result(result)
      when ActiveRecord::Base
        format_model_result(result)
      when Hash
        format_hash_result(result)
      end
    end

    def format_time_result(result)
      result.strftime("%Y-%m-%d %H:%M:%S")
    end

    def format_array_result(result)
      return result.inspect if result.length <= 10

      "#{result.first(10).map(&:inspect).join(", ")}, ... (#{result.length} total)"
    end

    def format_relation_result(result)
      return format_result(result.to_a) if result.loaded?

      "#{result.klass.name}(#{result.to_sql})"
    end

    def format_model_result(result)
      "#<#{result.class.name}:#{result.id}>"
    end

    def format_hash_result(result)
      return result.inspect if result.keys.length <= 10

      limited_hash = result.first(10).to_h
      "#{limited_hash.inspect}... (#{result.keys.length} total keys)"
    end

    def format_object_result(result)
      output = result.inspect
      return output if output.length <= 1000

      "#{output[0..1000]}... (truncated)"
    rescue StandardError => e
      "#{result} (inspect failed: #{e.message})"
    end
  end
end
