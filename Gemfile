source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'
gem 'coffee-rails'
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
# vendor prefixes
gem 'autoprefixer-rails'

# JS
# Use jquery as the JavaScript library
gem 'jquery-rails'
# jquery UI
gem 'jquery-ui-rails', '~> 5.0'
# AngularJS
gem 'angularjs-rails'
# datepicker
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

# config
gem 'config'

# translations for models
gem 'globalize', github: 'globalize/globalize'
gem 'activemodel-serializers-xml'

# inline svg for styling
gem 'inline_svg'

# clone activerecord models
gem 'deep_cloneable'

# tracking exceptions
gem 'rollbar'

# production - caching and passenger
group :production do
  gem 'rack-cache', :require => 'rack/cache'
  gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"
end

group :development do
  # add here rubocop, etc
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

  # tests coverage
  gem 'simplecov', :require => false
  gem 'codacy-coverage', :require => false
end
