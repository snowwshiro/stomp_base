# frozen_string_literal: true

require "active_record"

module StompBase
  class ModelsController < StompBase::ApplicationController
    # Disable Rails default layout to use LayoutComponent
    layout false

    def index
      @models = application_models
    end

    def show
      model_name = params[:id]
      model_class = get_model_class(model_name)

      return redirect_with_error(model_name) unless model_class

      @model_detail_component = build_model_detail_component(model_name, model_class)
    end

    private

    def redirect_with_error(model_name)
      redirect_to stomp_base_models_path, alert: "Model '#{model_name}' not found"
    end

    def build_model_detail_component(model_name, model_class)
      pagination_params = build_pagination_params
      records = fetch_paginated_records(model_class, pagination_params)
      pagination_info = build_pagination_info(model_class, pagination_params)

      StompBase::Pages::ModelDetailComponent.new(
        model_name: model_name,
        model_class: model_class,
        columns: model_class.column_names,
        records: records,
        pagination: pagination_info
      )
    end

    def build_pagination_params
      {
        limit: (params[:limit] || 100).to_i,
        offset: (params[:offset] || 0).to_i
      }
    end

    def fetch_paginated_records(model_class, pagination_params)
      model_class.limit(pagination_params[:limit]).offset(pagination_params[:offset])
    end

    def build_pagination_info(model_class, pagination_params)
      total_count = model_class.count
      limit = pagination_params[:limit]
      offset = pagination_params[:offset]

      {
        total_count: total_count,
        current_page: (offset / limit) + 1,
        per_page: limit,
        total_pages: (total_count.to_f / limit).ceil
      }
    end

    def application_models
      models = []
      eager_load_models_in_development

      ActiveRecord::Base.descendants.each do |model|
        next unless model_valid?(model)

        models << build_model_info(model)
      rescue StandardError => e
        Rails.logger.warn "Skipped model due to error: #{e.message}"
      end

      models.sort_by { |m| m[:name] }
    end

    def eager_load_models_in_development
      Rails.application.eager_load! if Rails.env.development?
    end

    def model_valid?(model)
      return false if model.name.start_with?("StompBase::")
      return false if model.abstract_class?
      return false unless model.table_exists?

      true
    end

    def build_model_info(model)
      {
        name: model.name,
        table_name: model.table_name,
        record_count: model.count,
        column_count: model.column_names.count
      }
    end

    def get_model_class(model_name)
      model_name.constantize
    rescue NameError
      nil
    end
  end
end
