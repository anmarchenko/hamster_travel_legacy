# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'travel-planner'

set :repo_url, 'git@github.com:altmer/travel-planner.git'
set :branch, 'master'

set :deploy_to, '/var/applications/travel_planner'
set :log_level, :debug

set :pty, true

set :linked_files, %w{config/settings.local.yml config/secrets  .yml}
set :linked_dirs, %w{bin log tmp/cache vendor/bundle public/system}

set :keep_releases, 5

namespace :god do
  def god_is_running
    capture(:bundle, "exec god status > /dev/null 2>&1 || echo 'god not running'") != 'god not running'
  end

  # Must be executed within SSHKit context
  def config_file_resque
    "#{release_path}/lib/god/resque.god"
  end

  def config_file_scheduler
    "#{release_path}/lib/god/resque_scheduler.god"
  end

  # Must be executed within SSHKit context
  def start_god
    execute :bundle, "exec god"
    execute :bundle, "exec god load #{config_file_resque}"
    execute :bundle, "exec god load #{config_file_scheduler}"
  end

  desc "Start god and his processes"
  task :start do
    on roles(:backend) do
      within release_path do
        with RAILS_ENV: fetch(:rails_env) do
          start_god
        end
      end
    end
  end

  desc "Terminate god and his processes"
  task :stop do
    on roles(:backend) do
      within release_path do
        if god_is_running
          execute :bundle, "exec god terminate"
        end
      end
    end
  end

  desc "Restart god's child processes"
  task :restart do
    on roles(:backend) do
      within release_path do
        with RAILS_ENV: fetch(:rails_env) do
          if god_is_running
            execute :bundle, "exec god load #{config_file_resque}"
            execute :bundle, "exec god load #{config_file_scheduler}"
            execute :bundle, "exec god restart"
          else
            start_god
          end
        end
      end
    end
  end
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      rvm = '~/.rvm/bin/rvm 2.2.3 do'
      cd = 'cd /var/applications/travel_planner/current;'
      execute "#{cd}RAILS_ENV=production #{rvm} bundle exec rake db:migrate"

      execute "if [ \"$( ps -A | grep ruby )\" ]; then killall -9 ruby; fi", pty: true

      [3000, 3001, 3002, 3003].each do |port|
        execute "cd /var/applications/travel_planner/current; #{rvm} bundle exec puma -p #{port} -e production -d"
      end
    end

    on roles(:backend), in: :sequence, wait: 5 do
      rvm = '~/.rvm/bin/rvm 2.2.3 do'
      cd = 'cd /var/applications/travel_planner/current;'

      # execute "if [ \"$( ps -A | grep ruby )\" ]; then killall -9 ruby; fi", pty: true
      # execute "#{cd}RAILS_ENV=production #{rvm} bundle exec rake websocket_rails:start_server"

    end
  end

  after :publishing, :restart

end

after "deploy:updated", "god:restart"
