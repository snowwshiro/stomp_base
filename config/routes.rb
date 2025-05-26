StompBase::Engine.routes.draw do
  root to: 'dashboard#index'
  get 'console', to: 'console#index'
  post 'console/execute', to: 'console#execute'
  
  get 'settings', to: 'settings#index'
  patch 'settings/locale', to: 'settings#update_locale', as: 'update_locale'
  
  resources :models, only: [:index, :show]
end