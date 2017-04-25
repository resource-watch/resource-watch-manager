# frozen_string_literal: true

# Main class of the program
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :connect_gateway

  def check_permissions
    logout_apigateway unless current_user && %w[ADMIN MANAGER].include?(current_user['role'])
  end

  def check_user_authentication
    logout_apigateway unless session[:user_token] && current_user
  end

  def redirect_to_apigateway
    redirect_to "#{ENV['APIGATEWAY_URL']}/auth?callbackUrl=#{auth_login_url}&token=true"
  end

  def logout_apigateway
    redirect_to "#{ENV['APIGATEWAY_URL']}/auth/logout?callbackUrl=#{auth_login_url}&token=true"
  end

  private

  def current_user
    return nil unless session[:user_token]
    return session[:current_user] if session[:current_user]
    get_current_user
  end

  def get_current_user
    connect = connect_gateway
    connect.authorization :Bearer, session[:user_token]
    response = connect.get('/auth/check-logged')
    if response.success?
      user_data = JSON.parse response.body
      session[:current_user] = user_data
      return session[:current_user]
    else
      return false
    end
  end

  def connect_gateway
    Faraday.new(url: (ENV['APIGATEWAY_URL']).to_s) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger, Rails.logger    # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end
