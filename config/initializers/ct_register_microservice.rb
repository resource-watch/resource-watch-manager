# frozen_string_literal: true
require 'ct_register_microservice'

CtRegisterMicroservice.configure do |config|
  config.ct_url = ENV.fetch('CT_URL')
  config.url = ENV.fetch('LOCAL_URL')
  config.ct_token = ENV.fetch('CT_TOKEN')
  config.swagger = __dir__ + '/../microservice/register.json'
  config.name = 'Dashboards microservice'
end
