# frozen_string_literal: true
require 'rw_api_microservice'

RwApiMicroservice.configure do |config|
  config.gateway_url = ENV.fetch('GATEWAY_URL')
  config.microservice_token = ENV.fetch('MICROSERVICE_TOKEN')
end
