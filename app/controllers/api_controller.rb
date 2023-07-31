# frozen_string_literal: true

class ApiController < ActionController::API
  before_action :set_private_cache_header
  before_action :validate_user_and_application, except: %i[health]
  before_action :authenticate, except: %i[index show health]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ApiKeyError, with: :no_api_key

  def validate_user_and_application
    validation_response = validate_request(request)

    return false unless validation_response

    log_request_to_cloud_watch(validation_response, request)

    @user = validation_response.dig('user') || {}
    request.params[:loggedUser] = @user

    return false unless @user
    return true if @user['id'].eql? 'microservice'

    has_valid_role = (@user.empty? or %w(ADMIN MANAGER USER).include? @user['role'])
    if (!has_valid_role)
      logger.debug 'Dashboard MS auth request: user has no valid roles, failing auth challenge'
      logger.debug 'User data: ' + @user.to_json
      render json: { errors: [{ status: '401', title: 'Unauthorized' }] }, status: 401
    end
  end

  protected

  def authenticate
    if @user.empty?
      render json: { errors: [{ status: '401', title: 'Unauthorized' }] }, status: 401
    end
  end

  def ensure_user_id_admin
    if @user['role'].equal? :ADMIN
      render json: { errors: [{ status: '403', title: 'ADMIN role is needed' }] }, status: 403
    end
  end

  def ensure_is_manager_or_admin
    unless %w(ADMIN MANAGER).include? @user['role']
      render json: { errors: [{ status: '403', title: 'ADMIN or MANAGER roles are needed' }] }, status: 403
    end
  end

  def ensure_user_has_requested_apps
    if @user.empty?
      render json: { errors: [{ status: '401', title: 'Unauthorized' }] }, status: 401
    end

    return if request.params.dig('data', 'attributes', 'application').nil?

    unless (request.params.dig('data', 'attributes', 'application') - @user.dig('extraUserData', 'apps')).empty?
      render json: { errors: [{ status: '403', title: 'Your user account does not have permissions to use the requested application(s)' }] }, status: 403
    end
  end

  def ensure_user_has_at_least_rw_app
    if request.params.dig('data', 'attributes', 'application').nil? and !@user.dig('extraUserData', 'apps').include? 'rw'
      render json: { errors: [{ status: '403', title: 'Your user account does not have permissions to use the default application(s)' }] }, status: 403 and return
    end
  end

  def record_not_found
    render json: { errors: [{ status: '404', title: 'Record not found' }] }, status: 404
  end

  def no_api_key
    render json: { errors: [{ status: '403', title: 'Required API key not found' }] }, status: 403
  end

  def set_envs
    @envs = [Environment::PRODUCTION]
    return true unless params[:env]

    if params[:env].eql?('all')
      @envs = nil
      return
    end

    envs = params[:env].split(',').map(&:downcase).map(&:strip)
    return true unless envs.compact.any?

    @envs = envs
  end

  def set_private_cache_header
    expires_in 24.hours
  end

  private

  def render_error(resource, status)
    render json: resource, status: status, adapter: :json_api,
           serializer: ActiveModel::Serializer::ErrorSerializer
  end

  def validate_request(request)
    logger.debug 'Validating request'

    if request.headers['Authorization'].nil?
      logger.debug 'No authorization header found'
    end

    if request.headers['x-api-key'].nil? && ENV.fetch('REQUIRE_API_KEY', true)
      raise ApiKeyError.new()
    end

    body = {}

    if request.headers['Authorization']
      body['userToken'] = request.headers['Authorization']
    end

    if request.headers['x-api-key']
      body['apiKey'] = request.headers['x-api-key']
    end

    if body.present?
      headers = {
        'Authorization' => "Bearer #{ENV.fetch('MICROSERVICE_TOKEN')}"
      }

      begin
        response = HTTParty.post("#{ENV.fetch('GATEWAY_URL')}/v1/request/validate", body: body, headers: headers)
      rescue => e
        logger.error "Error validating request: #{e.message}"
        render json: { 'errors': [{ detail: "Error validating request", status: 500 }] }, status: 500
        return false
      end

      logger.debug "Retrieved microserviceToken data, response status: #{response.code}"

      if (response.code >= 400)
        render json: response.parsed_response, status: response.code
        return false
      end

      response.parsed_response
    else
      {}
    end
  end

  def log_request_to_cloud_watch(validation_response, request)
    logger.debug 'Logging request to CloudWatch'

    log_query = request.query_parameters.except(:loggedUser)

    log_content = {
      request: {
        method: request.method,
        path: request.path,
        query: log_query
      }
    }

    if validation_response['user']
      user = validation_response['user']
      if user['id'] == 'microservice'
        log_content[:loggedUser] = { id: user['id'] }
      else
        log_content[:loggedUser] = {
          id: user['id'],
          name: user['name'],
          role: user['role'],
          provider: user['provider']
        }
      end
    else
      log_content[:loggedUser] = {
        id: 'anonymous',
        name: 'anonymous',
        role: 'anonymous',
        provider: 'anonymous'
      }
    end

    if validation_response['application']
      application_data = validation_response['application']['data']
      attributes = application_data['attributes']
      log_content[:requestApplication] = application_data.merge(attributes)
      log_content[:requestApplication].except!('attributes', 'type', 'createdAt', 'updatedAt')
    else
      log_content[:requestApplication] = {
        id: 'anonymous',
        name: 'anonymous',
        organization: nil,
        user: nil,
        apiKeyValue: nil
      }
    end

    CloudWatchService.instance.log_to_cloud_watch(log_content.to_json)
  end

end
