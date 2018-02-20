# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'

gem 'aws-sdk', '~> 2.3.0'
gem 'dotenv-rails'
gem 'faraday', '~> 0.11.0'
gem 'paperclip', '~> 5.2.0'
gem 'puma', '~> 3.7'
gem 'rack-cors'

# Active admin
gem 'activeadmin', github: 'activeadmin'
gem 'devise'

# Cronjobs
gem 'whenever', require: false

# Active record
gem 'active_model_serializers', '~> 0.10.6'
# Use this gem when supported by Rails 5.1
# gem 'activemodel-associations'
gem 'pg', '~> 0.18'

# Pagination
gem 'api-pagination'
gem 'draper'
gem 'will_paginate'

# Authentication and Authorization
gem 'jwt'

# Friendly id
gem 'friendly_id'

group :development, :test do
  gem 'annotate'
  gem 'byebug', platform: :mri
  gem 'rubocop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :test, :development do
  gem 'bullet' # Testing query performance
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'rack-reverse-proxy', require: 'rack/reverse_proxy'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
