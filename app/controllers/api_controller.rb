# frozen_string_literal: true

class ApiController < ActionController::API
  include ApiHelper

  before_action :load_user_from_request
  before_action :authenticate, except: %i[index show health]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def load_user_from_request
    @user = {}

    if request.params[:loggedUser].present? and request.params[:loggedUser].is_a? String
      @user = JSON.parse(request.params[:loggedUser]) || {}
    else
      @user = request.params[:loggedUser] || {}
    end

    has_valid_role = (@user.empty? or %w(ADMIN MANAGER USER).include? @user['role'])
    if (!has_valid_role)
      logger.debug 'Dashboard MS auth request: user has no valid roles, failing auth challenge'
      logger.debug 'User data: ' + @user.to_json
      render json: {errors: [{status: '401', title: 'Unauthorized'}]}, status: 401
    end
  end

  protected

  def authenticate
    if @user.empty?
      render json: {errors: [{status: '401', title: 'Unauthorized'}]}, status: 401
    end
  end

  def ensure_user_id_admin
    if @user['role'].equal? :ADMIN
      render json: {errors: [{status: '403', title: 'ADMIN role is needed'}]}, status: 403
    end
  end

  def ensure_is_manager_or_admin
    unless %w(ADMIN MANAGER).include? @user['role']
      render json: {errors: [{status: '403', title: 'ADMIN or MANAGER roles are needed'}]}, status: 403
    end
  end

  def ensure_user_has_requested_apps
    if @user.empty?
      render json: {errors: [{status: '401', title: 'Unauthorized'}]}, status: 401
    end

    return if request.params.dig('data', 'attributes', 'application').nil?

    unless (request.params.dig('data', 'attributes', 'application') - @user.dig('extraUserData', 'apps')).empty?
      render json: {errors: [{status: '403', title: 'Your user account does not have permissions to use the requested application(s)'}]}, status: 403
    end
  end

  def record_not_found
    render json: {errors: [{status: '404', title: 'Record not found'}]}, status: 404
  end

  private

  def render_error(resource, status)
    render json: resource, status: status, adapter: :json_api,
           serializer: ActiveModel::Serializer::ErrorSerializer
  end
end
