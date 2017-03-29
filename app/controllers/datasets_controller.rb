# frozen_string_literal: true

# Controller of the Datasets
class DatasetsController < ApplicationController
  before_action :check_user_authentication if Rails.env.production?

  def index; end

  def new
    gon.data = {
      authorization: 'Bearer ' + session[:user_token]
    }
  end

  def edit
    gon.data = {
      authorization: 'Bearer ' + session[:user_token],
      id: params[:id]
    }
  end
end
