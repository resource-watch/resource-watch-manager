# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApiHelper

  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :connect_gateway
  before_action :set_current_user

  def jwt_authentication
    redirect_to_apigateway unless session.key?('user_token')
  end

  def current_user
    unless session.key?('current_user')
      connect = connect_gateway
      connect.authorization :Bearer, session[:user_token]
      response = connect.get('/auth/check-logged')

      session[:current_user] = response.body
    end
  end

  def redirect_to_apigateway
    redirect_to "#{ENV['APIGATEWAY_URL']}/auth?callbackUrl=#{authentication_login_url}&token=true"
  end

  def logout_apigateway
    redirect_to "#{ENV['APIGATEWAY_URL']}/auth/logout?callbackUrl=#{authentication_login_url}&token=true"
  end

  def access_denied(_exception)
    logout_apigateway
  end

  protected

  def set_current_user
    current_user if session[:user_token].present?
    @current_user = session[:current_user] || nil
    Thread.current[:user] = @current_user # set on thread to use it on admin_authorization model
  end
end
