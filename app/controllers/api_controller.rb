# frozen_string_literal: true

class ApiController < ActionController::API
  include ApiHelper

  before_action :authenticate, except: %i[index show]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def authenticate_from_api
    begin
      token = request.env.fetch('HTTP_AUTHORIZATION', '').split(/Bearer /).last
      api_connection = connect_gateway
      api_connection.authorization :Bearer, token
      response = api_connection.get('/auth/check-logged')
      return true if response.success?
    rescue
    end
    false
  end

  protected

  def authenticate
    if !Rails.env.test? && !authenticate_from_api
      render json: { errors: [{ status: '401', title: 'Unauthorized' }] }, status: 401
    end
  end

  def record_not_found
    render json: { errors: [{ status: '404', title: 'Record not found' }] }, status: 404
  end

  private

  def render_error(resource, status)
    render json: resource, status: status, adapter: :json_api,
           serializer: ActiveModel::Serializer::ErrorSerializer
  end
end
