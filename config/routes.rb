Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount Litestream::Engine, at: "/litestream"

  get "posts.atom", to: redirect("feed.atom")

  resource :token, only: :create
  resources :posts
  resource :feed, only: :show

  get "*paths", to: "webs#show", constraints: ->(req) {
    !req.xhr? && req.format.html?
  }
end
