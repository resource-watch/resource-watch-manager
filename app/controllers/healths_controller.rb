class HealthsController < ApplicationController
  def index
    render json: { success: true, message: 'PONG' }, status: 200
  end
end
