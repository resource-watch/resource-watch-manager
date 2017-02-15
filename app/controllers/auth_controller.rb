class AuthController < ApplicationController

  def login
    if params.key?('token')
      session[:user_token] = params[:token]
      redirect_to root_path if current_user
    else
      redirect_to_apigateway
    end
  end

  def logout
    session.delete(:user_token)
    session.delete(:current_user)
    logout_apigateway
  end

end
