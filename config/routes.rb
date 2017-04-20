# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  resources :insights
  root to: 'datasets#index'

  # Admin models
  resources :datasets, only: %i[index new edit] do
    resources :metadata, only: %i[index]
    resources :dataset_vocabularies, only: %i[index]
    resources :widgets, only: %i[index new edit]
  end
  resources :partners, only: %i[index new create edit update destroy]
  resources :static_pages, only: %i[index new create edit update destroy]
  resources :insights, only: %i[index new create edit update destroy]
  resources :categories do
    resources :subcategories
  end
  resources :vocabularies, only: %i[index]

  # API
  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :partners, only: %i[index show]
      resources :static_pages, only: %i[index show create delete update]
      resources :insights, only: %i[index show]
      resources :categories, only: %i[index show]
      resources :subcategories, only: %i[index show]
    end
  end

  # Auth
  get 'auth/login', to: 'auth#login'
  get 'auth/logout', to: 'auth#logout'
end
