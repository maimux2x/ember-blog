Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount Litestream::Engine, at: "/litestream"

  resource :token, only: :create
  resources :posts
  resource :feed, only: :show

  get "posts.atom", to: redirect("feed.atom")
end
