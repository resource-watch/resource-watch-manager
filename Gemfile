# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.2'

gem 'rails', '~> 7.0.4'

gem 'aws-sdk-s3', '~> 1.114.0'
gem 'dotenv-rails', '~> 2.8.1'
gem 'faraday', '~> 2.5.2'
gem 'kt-paperclip', "~> 6.4", ">= 6.4.1"
gem 'puma', '~> 5.6.5'
gem 'rack-cors', '~> 1.1.1'
gem 'sprockets-rails', '~> 3.4.2'

# Mail
gem 'sendgrid-ruby'

# Cronjobs
gem 'whenever', require: false

# Active record
gem 'active_model_serializers', '~> 0.10.13'
gem 'pg', '~> 1.4.3'

# Pagination
gem 'api-pagination'
gem 'draper'
gem 'will_paginate'
gem 'kaminari'

# Authentication and Authorization
gem 'jwt'

# Friendly id
gem 'friendly_id'

gem 'rw-api-microservice', '~> 2.0.0'

gem 'aws-sdk-cloudwatchlogs'

group :development, :test do
  gem 'annotate'
  gem 'byebug', platform: :mri
  gem 'rubocop'
  gem 'simplecov'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rack-reverse-proxy', require: 'rack/reverse_proxy'
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

group :test do
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
