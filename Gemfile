# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.3.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.0.rc1'

# Rails plugins
gem 'dotenv-rails'
gem 'faraday', '~> 0.11.0'
gem 'gon'
gem 'paperclip'
gem 'puma', '~> 3.7'
gem 'rack-cors'
gem 'slim-rails'

# Active record
gem 'active_model_serializers', '~> 0.10.0'
gem 'pg', '~> 0.18'
gem 'simple_form'

# Assets management
gem 'autoprefixer-rails'
gem 'foundation-rails'
gem 'jquery-rails'
gem 'sass-rails', github: 'rails/sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

source 'https://rails-assets.org' do
end

group :development, :test do
  gem 'annotate'
  gem 'byebug', platform: :mri
  gem 'rubocop'
end

group :development do
  # Access an IRB console on exception pages ...
  # or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)
