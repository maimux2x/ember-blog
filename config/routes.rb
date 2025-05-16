Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount Litestream::Engine, at: "/litestream"

  resource :token
  resources :posts
end
