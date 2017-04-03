class MetadataController < ApplicationController

  before_action :check_user_authentication if Rails.env === 'production'

  def index
    gon.data = {
      authorization: 'Bearer ' + user_token,
      dataset_id: params[:dataset_id]
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
      dataset_id: params[:dataset_id]
    }
  end

  private
    def user_token
      if session.has_key?(:user_token)
        session[:user_token]
      else
        ''
      end
    end
end