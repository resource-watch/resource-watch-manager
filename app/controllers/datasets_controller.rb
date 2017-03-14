class DatasetsController < ApplicationController

  before_filter :check_user_authentication

  def index
  end

  def new
  end

  def edit
    @dataset_id = params[:id]
  end

end
