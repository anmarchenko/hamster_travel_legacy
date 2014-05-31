source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'
gem 'russian'

# DB
gem 'mongoid', github: 'mongoid/mongoid'
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
gem 'devise'

# CSS
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
# twitter bootstrap css & javascript toolkit
gem 'twitter-bootswatch-rails', '~> 3.1.1'
# twitter bootstrap helpers gem, e.g., alerts etc...
gem 'twitter-bootswatch-rails-helpers'
# font awesome icons
gem 'font-awesome-rails'

gem 'compass-rails'

# JS
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# jquery UI
gem 'jquery-ui-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# chosen js library
gem 'chosen-rails'
# AngularJS magic framework
gem 'angularjs-rails'
gem 'angular-ui-bootstrap-rails', '0.10.0'
gem 'angularjs-rails-resource', '~> 1.0.0'

# other
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  # Use Capistrano for deployment
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'

  # app server
  gem 'puma'

  # show errors
  gem 'better_errors'
  gem 'binding_of_caller'
end

# tests
group :test do
  # BDD unit testing
  gem 'rspec'
  gem 'rspec-rails'
  gem 'fuubar', :require => false

  # BDD integration testing
  gem 'minitest'
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'

  # matchers for tests
  gem 'shoulda-matchers'
  # time stubs and mocks
  gem 'timecop'
  # test data fixtures
  gem 'factory_girl'
  gem 'factory_girl_rails'
  # integration test
  gem 'capybara'

  # fork for tests
  gem 'spork', '~> 1.0rc'
  gem 'spork-rails'
end