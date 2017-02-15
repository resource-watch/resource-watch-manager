class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :connect_gateway

  def check_user_authentication
    redirect_to_apigateway unless current_user
  end

  def redirect_to_apigateway
    redirect_to "#{ENV['APIGATEWAY_URL']}/auth?callbackUrl=#{auth_login_url}&token=true"
  end

  def logout_apigateway
    redirect_to "#{ENV['APIGATEWAY_URL']}/auth/logout?callbackUrl=#{auth_login_url}&token=true"
  end

  private

    def current_user
      @current_user ||= get_current_user if session[:user_token]
    end

    def get_current_user
      connect = connect_gateway
      connect.authorization :Bearer, session[:user_token]
      response = connect.get('/auth/check-logged')
      session[:current_user] = response.body
    end

    def connect_gateway
      Faraday.new(url: "#{ENV['APIGATEWAY_URL']}") do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

end
