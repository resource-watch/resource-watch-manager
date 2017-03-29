# frozen_string_literal: true

Rails.application.routes.draw do
  resources :static_pages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'dashboard#index'

  # Admin models
  resources :datasets, only: %i(index new edit)
  resources :partners, only: %i(index new create edit update)

  # API
  namespace :api do
    resources :partners, only: %i(index show)
  end

  # Auth
  get 'auth/login', to: 'auth#login'
  get 'auth/logout', to: 'auth#logout'
end
