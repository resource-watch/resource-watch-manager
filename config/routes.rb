# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do

  # Active Admin routes
  get 'admin', to: 'admin/dashboard_page#index'
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  # API
  namespace :api, defaults: { format: :json } do
    resources :partners
    resources :static_pages
    resources :dashboards
    resources :tools
    resources :temporary_content_images, only: [:create]
    resources :profiles, only: [:show, :create, :update, :destroy]
  end

end
