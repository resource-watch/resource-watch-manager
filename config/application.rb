# frozen_string_literal: true

require_relative 'boot'

require "rails"

%w(
  active_record/railtie
  action_controller/railtie
  action_mailer/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

require 'rw_api_microservice'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ResourceWatchManager
  # Application class
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.load_defaults Rails::VERSION::STRING.to_f

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

    # For active admin views
    config.middleware.use ActionDispatch::Flash
  end
end
