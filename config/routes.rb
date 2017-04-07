# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'datasets#index'

  # Admin models
  resources :datasets, only: %i(index new edit) do
    resources :metadata, only: %i(index)
    resources :vocabularies, only: %i(index)
  end
  resources :partners, only: %i(index new create edit update destroy)
  resources :static_pages, only: %i(index new create edit update destroy)
  resources :categories do
    resources :subcategories do
      resources :dataset_subcategories
    end
  end

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
