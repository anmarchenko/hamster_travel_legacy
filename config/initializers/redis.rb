# frozen_string_literal: true
$redis = Redis.new(host: (ENV['REDIS_HOST'] || 'localhost'), port: 6379, driver: :hiredis)
