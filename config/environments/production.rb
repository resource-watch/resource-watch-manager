# frozen_string_literal: true

Rails.application.configure do
  # Make javascript_pack_tag lookup digest hash to enable long-term caching
  config.x.webpacker[:digesting] = true

  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  # config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  # config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version`
  # have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "resource-watch-manager_#{Rails.env}"
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  LOG_LEVELS = %w[DEBUG INFO WARN ERROR FATAL UNKNOWN].freeze
  level ||= LOG_LEVELS.index ENV.fetch("LOGGER_LEVEL", "WARN") # default to WARN index: 2
  level ||= Logger::WARN  # FIX default in case of environment LOG_LEVEL value is present but not correct

  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  logger.level = level
  config.logger = ActiveSupport::TaggedLogging.new(logger)

  config.log_level = LOG_LEVELS[level]

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Paperclip S3
  config.paperclip_defaults = {
    storage: :s3,
    preserve_files: true,
    s3_protocol: :https,
    path: "#{ENV.fetch('S3_PATH')}/:class/:attachment/:id_partition/:style/:filename",
    s3_region: ENV.fetch('S3_AWS_REGION'),
    s3_credentials: {
      bucket: ENV.fetch('S3_BUCKET_NAME'),
      access_key_id: ENV.fetch('S3_AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('S3_AWS_SECRET_ACCESS_KEY')
    },
    s3_permissions: 'public-read'
  }
end
