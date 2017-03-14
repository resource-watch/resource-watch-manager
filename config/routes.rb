Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "dashboard#index"

  # Admin models
  resources :datasets, only: [:index, :edit]
  resources :partners, only: [:index, :new, :create, :edit, :update]

  # API
  namespace :api do
    get 'partners', to: 'partners#index'
  end

  # Auth
  get 'auth/login', to: 'auth#login'
  get 'auth/logout', to: 'auth#logout'
end
