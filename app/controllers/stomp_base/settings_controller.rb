# frozen_string_literal: true

class StompBase::SettingsController < StompBase::ApplicationController
  def index
    # 設定画面を表示
  end

  def update_locale
    locale = params[:locale]
    
    if StompBase.configuration.available_locales.include?(locale.to_sym)
      StompBase.locale = locale
      session[:stomp_base_locale] = locale
      
      respond_to do |format|
        format.json { render json: { status: 'success', locale: locale } }
        format.html { redirect_back(fallback_location: stomp_base.root_path, notice: t('settings.language_updated')) }
      end
    else
      respond_to do |format|
        format.json { render json: { status: 'error', message: t('settings.invalid_locale') }, status: :unprocessable_entity }
        format.html { redirect_back(fallback_location: stomp_base.root_path, alert: t('settings.invalid_locale')) }
      end
    end
  end
end
