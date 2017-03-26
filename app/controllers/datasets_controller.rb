class DatasetsController < ApplicationController

  before_action :check_user_authentication if Rails.env === 'production'

  def index
  end

  def new
  end

  def edit
    gon.edit = {
      authorization: session[:user_token],
      id: params[:id]
    }
  end

end
