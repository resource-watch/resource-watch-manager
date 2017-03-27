source 'https://rubygems.org'

ruby '2.3.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.0.rc1'

# Rails plugins
gem 'puma', '~> 3.7'
gem 'dotenv-rails'
gem 'faraday', '~> 0.11.0'
gem 'slim-rails'
gem 'paperclip'
gem 'rack-cors'
gem 'gon'

# Active record
gem 'pg', '~> 0.18'
gem 'simple_form'
gem 'active_model_serializers', '~> 0.10.0'

# Assets management
gem 'webpacker'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'sass-rails', github: 'rails/sass-rails'
gem 'autoprefixer-rails'
gem 'foundation-rails'

source 'https://rails-assets.org' do
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
