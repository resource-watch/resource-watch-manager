# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  get 'health', to: 'health#health'

  mount RwApiMicroservice::Engine => '/'

  # API
  namespace :api, defaults: { format: :json } do
    resources :partners
    resources :static_pages
    resources :dashboards do
      member do
        post :clone
      end
    end
    resources :topics do
      member do
        post :clone
        post 'clone-dashboard', to: :clone_dashboard
      end
    end
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
end
