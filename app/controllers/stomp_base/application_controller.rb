class StompBase::ApplicationController < ActionController::Base
  include StompBase::I18nHelper
  include StompBase::Authentication
  
  layout 'stomp_base/application'

  before_action :set_locale

  # ヘルパーメソッドとしてI18nHelperのメソッドを追加
  helper_method :available_locales, :current_locale, :locale_name

  private

  def set_locale
    # セッションから保存されたロケールを復元、なければ設定から取得
    locale = session[:stomp_base_locale] || StompBase.locale
    
    if StompBase.configuration.available_locales.include?(locale.to_sym)
      I18n.locale = locale
      StompBase.locale = locale
    else
      I18n.locale = StompBase.locale
    end
  end
end
