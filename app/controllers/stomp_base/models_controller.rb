class StompBase::ModelsController < StompBase::ApplicationController
  def index
    @models = get_application_models
  end

  def show
    @model_name = params[:id]
    @model_class = get_model_class(@model_name)
    
    if @model_class
      @columns = @model_class.column_names
      @records = @model_class.limit(params[:limit] || 100).offset(params[:offset] || 0)
      @total_count = @model_class.count
      @current_page = (params[:offset].to_i / (params[:limit] || 100).to_i) + 1
      @per_page = (params[:limit] || 100).to_i
      @total_pages = (@total_count.to_f / @per_page).ceil
    else
      redirect_to stomp_base.models_path, alert: "Model '#{@model_name}' not found"
    end
  end

  private

  def get_application_models
    models = []
    
    # Railsアプリケーションの全モデルを取得
    Rails.application.eager_load! if Rails.env.development?
    
    ActiveRecord::Base.descendants.each do |model|
      # エンジン自体のモデルは除外し、アプリケーションのモデルのみを対象とする
      next if model.name.start_with?('StompBase::')
      next if model.abstract_class?
      next unless model.table_exists?
      
      models << {
        name: model.name,
        table_name: model.table_name,
        count: model.count,
        columns: model.column_names.count
      }
    rescue => e
      # エラーが発生したモデルはスキップ
      Rails.logger.warn "Skipped model due to error: #{e.message}"
    end
    
    models.sort_by { |m| m[:name] }
  end

  def get_model_class(model_name)
    model_name.constantize
  rescue NameError
    nil
  end
end
