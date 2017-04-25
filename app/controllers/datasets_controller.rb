# frozen_string_literal: true

# Controller of the Datasets
class DatasetsController < ApplicationController
  before_action :check_user_authentication if Rails.env.production?
  before_action :check_permissions if Rails.env.production?

  def index
    gon.data = {
      authorization: 'Bearer ' + user_token
    }
  end

  def new
    gon.data = {
      authorization: 'Bearer ' + user_token
    }
  end

  def edit
    gon.data = {
      authorization: 'Bearer ' + user_token,
      id: params[:id]
    }
  end

  private

  def user_token
    if session.key?(:user_token)
      session[:user_token]
    else
      ''
    end
  end
end
