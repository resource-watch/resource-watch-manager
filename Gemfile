source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.3.3'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

# Rails plugins
gem 'puma', '~> 3.0'
gem 'dotenv-rails', '~> 2.2.0'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'faraday', '~> 0.11.0'
gem 'slim-rails'

# Active record
gem 'pg', '~> 0.18'

# Assets management
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'autoprefixer-rails'
gem 'react-rails'
gem 'turbolinks', '~> 5.x'
gem 'foundation-rails'

source 'https://rails-assets.org' do
  gem 'rails-assets-react-select'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
