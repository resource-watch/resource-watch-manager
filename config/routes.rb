Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "dashboard#index"

  # Auth
  get 'auth/login', to: 'auth#login'
  get 'auth/logout', to: 'auth#logout'
end
