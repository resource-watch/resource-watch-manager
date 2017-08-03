# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  # API
  namespace :api, defaults: { format: :json } do
    resources :partners
    resources :static_pages
    resources :dashboards
  end

  get '/healthz', 'health#index'
end
