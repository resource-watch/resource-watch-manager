Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "datasets#index"

  # Admin models
  resources :datasets, only: [:index, :new, :edit] do
    resources :metadata, only: [:index, :new, :edit]
  end
  resources :partners, only: [:index, :new, :create, :edit, :update]

  # API
  namespace :api do
    resources :partners, only: [:index, :show]
  end

  # Auth
  get 'auth/login', to: 'auth#login'
  get 'auth/logout', to: 'auth#logout'
end
