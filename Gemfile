# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'
gem 'russian'

# DB
gem 'annotate'
gem 'pg'

# pagination
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'kaminari-i18n'
# validate dates
gem 'date_validator'

# authentication
gem 'devise', '~> 4.2.0'
gem 'omniauth-google-oauth2'

# asset pipeline
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# CSS
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# vendor prefixes
gem 'autoprefixer-rails'

# JS
# Use jquery as the JavaScript library
gem 'jquery-rails'
# jquery UI
gem 'jquery-ui-rails'
# AngularJS
gem 'angularjs-rails'
# datepicker
gem 'bootstrap-datepicker-rails'

# app server
gem 'puma'

# docx
gem 'docx_rails', git: 'https://github.com/altmer/docx-rails'
gem 'rubyzip'
gem 'zip-zip' # will load compatibility for old rubyzip API.

# redis for in-memory store
gem 'hiredis'
gem 'redis', require: ['redis', 'redis/connection/hiredis']

# image uploading
gem 'dragonfly'
gem 'dragonfly-s3_data_store'
gem 'xmlrpc' # required by fog

# caching
gem 'dalli'

# money
gem 'eu_central_bank'
gem 'money'
gem 'money-rails'

# geo
gem 'countries'

# config
gem 'config'

# translations for models
gem 'activemodel-serializers-xml'
gem 'globalize', git: 'https://github.com/globalize/globalize'

# inline svg for styling
gem 'inline_svg'

# clone activerecord models
gem 'deep_cloneable'

# tracking exceptions
gem 'rollbar'
# monitoring
gem 'newrelic_rpm'

# production - caching and passenger
group :production do
  gem 'passenger', '>= 5.0.25', require: 'phusion_passenger/rack_handler'
  gem 'rack-cache', require: 'rack/cache'
end

group :development do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'rubocop'
end

group :test do
  # unit testing
  gem 'database_cleaner'
  gem 'rspec-rails'

  # matchers for tests
  gem 'shoulda-matchers'
  # time stubs and mocks
  gem 'timecop'
  # test data fixtures
  gem 'factory_girl_rails'
  # better data for fixtures
  gem 'faker'

  # tests coverage
  gem 'simplecov', require: false
end
