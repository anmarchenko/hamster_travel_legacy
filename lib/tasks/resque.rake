# Resque tasks
require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do
  task :setup => :environment do
    require 'resque'

    Resque.redis = "#{ENV['REDIS_HOST'] || 'localhost'}:6379"
  end

  task :setup_schedule => :setup do
    require 'resque-scheduler'

    Resque.redis = "#{ENV['REDIS_HOST'] || 'localhost'}:6379"

    # The schedule doesn't need to be stored in a YAML, it just needs to
    # be a hash.  YAML is usually the easiest.
    Resque.schedule = YAML.load_file('config/resque_scheduler.yml')
  end

  task :scheduler_setup => :setup_schedule
end
