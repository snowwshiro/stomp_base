class StompBase::ConsoleController < StompBase::ApplicationController
  def index
    # Render the console view
  end

  def execute
    command = params[:command]
    result = Rails.application.eager_load! # Ensure all classes are loaded
    result = eval(command) # Execute the command in the Rails context
    render json: { result: result }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
