# frozen_string_literal: true

StompBase::Engine.routes.draw do
  root to: "dashboard#index"

  # Application controller routes for testing
  get "application", to: "application#index"

  get "settings", to: "settings#index"
  patch "settings", to: "settings#update"
  post "settings", to: "settings#update"
  patch "settings/locale", to: "settings#update_locale", as: "update_locale"
  post "settings/locale", to: "settings#update_locale"

  # Console routes
  get "console", to: "console#index"
  post "console/execute", to: "console#execute"

  resources :models, only: %i[index show]
end
