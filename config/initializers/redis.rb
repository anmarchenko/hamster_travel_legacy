$redis = Redis.new(host: (ENV['REDIS_HOST'] || 'localhost'), port: 6379, driver: :hiredis)
Resque.redis = "#{ENV['REDIS_HOST'] || 'localhost'}:6379"
