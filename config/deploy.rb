# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'travel-planner'

set :repo_url, 'git@github.com:altmer/travel-planner.git'
set :branch, 'master'

set :deploy_to, '/var/applications/travel_planner'
set :log_level, :debug

set :pty, true

set :linked_files, %w{config/secrets.yml}
set :linked_dirs, %w{bin log tmp/cache vendor/bundle public/system}

set :keep_releases, 5

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
