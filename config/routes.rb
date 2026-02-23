Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount Litestream::Engine, at: "/litestream"

  get "posts.atom", to: redirect("feed.atom")

  resource :feed, only: :show

  scope :api, defaults: { format: :json } do
    resource :token, only: :create
    resources :posts

    resources :csv_imports, only: %i[index show create]
  end

  get "*paths", to: "webs#show", constraints: ->(req) {
    !req.xhr? && req.format.html?
  }
end
