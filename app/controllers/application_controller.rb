class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :connect_gateway
  before_action :set_current_user

  def jwt_authentication
    unless session.key?('user_token')
      redirect_to_apigateway
    end
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
    redirect_to "#{ENV['APIGATEWAY_URL']}/auth?callbackUrl=#{auth_login_url}&token=true"
  end

  def logout_apigateway
    redirect_to "#{ENV['APIGATEWAY_URL']}/auth/logout?callbackUrl=#{auth_login_url}&token=true"
  end

  def access_denied(exception)
    render json: { unpermitted: exception.message }
  end

  protected

  # def current_user
  #   return nil unless session[:user_token]
  #   return session[:current_user] if session[:current_user]
  #   get_current_user
  # end

  # def get_current_user
  #   connect = connect_gateway
  #   connect.authorization :Bearer, session[:user_token]
  #   response = connect.get('/auth/check-logged')
  #   if response.success?
  #     user_data = JSON.parse response.body
  #     session[:current_user] = user_data
  #     return session[:current_user]
  #   else
  #     return false
  #   end
  # end

  def connect_gateway
    Faraday.new(url: (ENV['APIGATEWAY_URL']).to_s) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger, Rails.logger    # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def set_current_user
    current_user if session[:user_token].present?
    @current_user = session[:current_user] || nil
    Thread.current[:user] = @current_user # set on thread to use it on admin_authorization model
  end

end
