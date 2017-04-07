# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require 'rack'
require 'rack/cache'
require 'redis-rack-cache'

use Rack::Cache,
    metastore: "redis://#{ENV['REDIS_HOST']}:6379/1/metastore",
    entitystore: "redis://#{ENV['REDIS_HOST']}:6379/1/entitystore"

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
