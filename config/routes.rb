# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  root to: 'dashboard#index'

  # Admin models
  resources :datasets, only: %i(index new edit)
  resources :partners, only: %i(index new create edit update)
  resources :static_pages, only: %i(index new create edit update destroy)

  # API
  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :partners, only: %i(index show)
      resources :static_pages, only: %i(index show)
    end
  end

  # Auth
  get 'auth/login', to: 'auth#login'
  get 'auth/logout', to: 'auth#logout'
end
