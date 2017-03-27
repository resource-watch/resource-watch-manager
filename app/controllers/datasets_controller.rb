class DatasetsController < ApplicationController

  before_action :check_user_authentication if Rails.env === 'production'

  def index
  end

  def new
  end

  def edit
    @dataset_id = params[:id]
  end

end
