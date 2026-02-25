Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope defaults: { format: :json } do
    post "/signup", to: "users#create"
    get "/profile", to: "users#show"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :studies, only: %i[index show create] do
      resources :submissions, only: :create
    end
  end
end
