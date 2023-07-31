# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'rails', '~> 7.0.6'

gem 'aws-sdk-s3', '~> 1.132.0'
gem 'dotenv-rails', '~> 2.8.1'
gem 'kt-paperclip', "~> 7.2.0"
gem 'puma', '~> 6.3.0'
gem 'rack-cors', '~> 2.0.1'
gem 'sprockets-rails', '~> 3.4.2'

# Mail
gem 'sendgrid-ruby', '~> 6.6.2'

# Active record
gem 'active_model_serializers', '~> 0.10.13'
gem 'pg', '~> 1.5.3'

# Pagination
gem 'api-pagination', '~> 5.0.0'
gem 'will_paginate', '~> 4.0'
gem 'kaminari', '~> 1.2.2'

# Friendly id
gem 'friendly_id'

gem 'rw-api-microservice', '~> 2.0.0'

gem 'aws-sdk-cloudwatchlogs', '~> 1.69.0'

group :development, :test do
  gem 'annotate', '~> 3.2.0'
  gem 'byebug', '~> 11.1.3', platform: :mri
  gem 'rubocop', '~> 1.55.1'
  gem 'simplecov', '~> 0.22.0'
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'ffaker', '~> 2.21.0'
  gem 'rack-reverse-proxy', '~> 0.12.0', require: 'rack/reverse_proxy'
end

group :development do
  gem 'listen', '~> 3.8.0'
  gem 'spring', '~> 4.1.1'
  gem 'spring-watcher-listen', '~> 2.1.0'
end

group :test do
  gem 'database_cleaner', '~> 2.0.2'
  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'rspec-rails', '~> 6.0.3'
  gem 'shoulda-matchers', '~> 5.3.0'
  gem 'vcr', '~> 6.2.0'
  gem 'webmock', '~> 3.18.1'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
