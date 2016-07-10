source 'https://rubygems.org'

gem 'rails', '5.0.0'
gem 'russian'

# DB
gem 'pg'
gem 'annotate'

# pagination
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'kaminari-i18n'
# validate dates
gem 'date_validator'

# views
gem 'haml'
gem 'haml-rails'

# authentication
gem 'devise', '~> 4.2.0'

# asset pipeline
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# CSS
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# font awesome icons
gem 'font-awesome-rails'

# JS (most of these gems must die)
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# jquery UI
gem 'jquery-ui-rails', '~> 5.0'
# AngularJS
gem 'angularjs-rails'
# Jcrop library for cropping images before upload
gem 'jcrop-rails-v2'
# dates
gem 'bootstrap-datepicker-rails'

# app server
gem 'puma'

# docx
gem 'rubyzip'
gem 'docx_rails', github: 'altmer/docx-rails'
gem 'zip-zip' # will load compatibility for old rubyzip API.

# redis for in-memory store
gem 'hiredis'
gem 'redis', :require => ["redis", "redis/connection/hiredis"]

# image uploading
gem 'dragonfly'
gem 'dragonfly-s3_data_store'

# caching
gem 'dalli'

# money
gem 'money'
gem 'money-rails'
gem 'eu_central_bank'

# geo
gem 'countries'

# background jobs
gem 'resque'
gem 'god'
gem 'resque-scheduler'

# config
gem 'config'

# translations for models
gem 'globalize', github: 'globalize/globalize'
gem 'activemodel-serializers-xml'

# inline svg for styling
gem 'inline_svg'

# clone activerecord models
gem 'deep_cloneable'

# production - caching and passenger
group :production do
  gem 'rack-cache', :require => 'rack/cache'
  gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"
end

group :development do
  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.5.0'
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rvm',   '~> 0.1', require: false
end

group :test do
  # unit testing
  gem 'rails-controller-testing'
  gem 'rspec', '~> 3.4'
  gem 'rspec-rails', '~> 3.4'
  gem 'nyan-cat-formatter'
  gem 'database_cleaner'

  # matchers for tests
  gem 'shoulda-matchers'
  # time stubs and mocks
  gem 'timecop'
  # test data fixtures
  gem 'factory_girl'
  gem 'factory_girl_rails'
  # better data for fixtures
  gem 'faker'
  # integration test
  gem 'capybara'

  # tests coverage
  gem 'simplecov', :require => false
  gem 'codacy-coverage', :require => false
end