# frozen_string_literal: true

# Class for the authentication controller
class AuthController < ApplicationController
  def login
    if params.key?('token')
      session[:user_token] = params[:token]
      if current_user && %w[ADMIN MANAGER].include?(current_user['role'])
        redirect_to root_path
      else
        logout
      end
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
