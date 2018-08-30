# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'action_view/railtie'
# require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'
require 'ct_register_microservice'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ResourceWatchManager
  # Application class
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.load_defaults 5.1

    # Only API
    config.api_only = true

    # Setup scaffold
    config.generators do |g|
      g.assets          false
      g.helper          false
      g.test            false
    end

    # CORS
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get post options patch delete]
      end
    end

    unless Rails.env.production?
      config.middleware.insert(0, Rack::ReverseProxy) do
        reverse_proxy_options preserve_host: false
        reverse_proxy '/api/dataset', "#{ENV.fetch('APIGATEWAY_URL')}/dataset"
        reverse_proxy '/api/widget', "#{ENV.fetch('APIGATEWAY_URL')}/widget"
        reverse_proxy '/api/layer', "#{ENV.fetch('APIGATEWAY_URL')}/layer"
      end
    end

    # For active admin views
    config.middleware.use ActionDispatch::Flash
  end
end
