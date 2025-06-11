Rails.application.routes.draw do
  # Mount StompBase engine
  mount StompBase::Engine, at: "/stomp_base"
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # You can define a simple root endpoint for API info
  root "api#info"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end