# frozen_string_literal: true

class ApiController < ActionController::API
  include ApiHelper

  before_action :authenticate, except: %i[index show health]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def authenticate_from_api
    user_data = JSON.parse request.env.fetch('HTTP_USER_KEY', '{}')
    has_user_or_admin_role = (user_data.present? and %w(ADMIN USER).include? user_data['role'])
    if (!has_user_or_admin_role)
      logger.debug 'Dashboard MS auth request: user has no valid roles, failing auth challenge'
      logger.debug 'User data: ' + user_data
    end
    has_user_or_admin_role
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
