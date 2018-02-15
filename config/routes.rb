# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  # Active Admin routes
  get 'manager', to: 'manager/dashboards#index'
  ActiveAdmin.routes(self)

  # API
  namespace :api, defaults: { format: :json } do
    resources :partners
    resources :static_pages
    resources :dashboards
    resources :tools
    resources :temporary_content_images, only: [:create]
    resources :profiles, only: %i[show create update destroy]
    resources :faqs do
      collection do
        post 'reorder'
      end
    end
    post 'contact-us', to: 'contacts#create'
  end

  # Auth
  get 'authentication/login', to: 'auth#login'
  get 'authentication/logout', to: 'auth#logout'
end
