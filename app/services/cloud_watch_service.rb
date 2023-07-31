require 'aws-sdk-cloudwatchlogs'
require 'singleton'

class CloudWatchService
  include Singleton

  def initialize
    @cloud_watch_service = Aws::CloudWatchLogs::Client.new
    @log_group_name = ENV.fetch('CLOUDWATCH_LOG_GROUP_NAME', 'api-keys-usage')
    @log_stream_name = 'resource-watch-manager'

    create_log_group
    create_log_stream
  end

  def log_to_cloud_watch(log_message)
    put_log_events_params = {
      log_group_name: @log_group_name,
      log_stream_name: @log_stream_name,
      log_events: [
        {
          message: log_message,
          timestamp: Time.now.to_i * 1000 # Convert to milliseconds
        }
      ]
    }

    begin
      put_log_events_response = @cloud_watch_service.put_log_events(put_log_events_params)
      Rails.logger.debug "Successfully logged to CloudWatch: #{put_log_events_response}"
    rescue StandardError => e
      Rails.logger.error "Error logging to CloudWatch: #{e}"
      raise e
    end
  end

  private

  def create_log_group
    create_log_group_params = {
      log_group_name: @log_group_name
    }

    begin
      @cloud_watch_service.create_log_group(create_log_group_params)
      Rails.logger.debug "Log group '#{@log_group_name}' created successfully."
    rescue Aws::CloudWatchLogs::Errors::ResourceAlreadyExistsException
      Rails.logger.debug "Log group '#{@log_group_name}' already exists."
    rescue StandardError => e
      Rails.logger.warn "Error creating log group: #{e}"
      raise e
    end
  end

  def create_log_stream
    create_log_stream_params = {
      log_group_name: @log_group_name,
      log_stream_name: @log_stream_name
    }

    begin
      @cloud_watch_service.create_log_stream(create_log_stream_params)
      Rails.logger.debug "Log stream '#{@log_stream_name}' created successfully."
    rescue Aws::CloudWatchLogs::Errors::ResourceAlreadyExistsException
      Rails.logger.debug "Log stream '#{@log_stream_name}' already exists."
    rescue StandardError => e
      Rails.logger.warn "Error creating log stream: #{e}"
      raise e
    end
  end
end
