class AuthController < ApplicationController

  def login
    token = params[:token]
    if token.nil?
      redirect_to_apigateway
    else
      session[:user_token] = token
      redirect_to root_path
    end
  end

  def logout
    session.delete(:user_token)
    session.delete(:current_user)
    redirect_to_apigateway
  end

end
