# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'travel-planner'

set :repo_url, 'git@github.com:altmer/travel-planner.git'
set :branch, 'master'

set :deploy_to, '/var/applications/travel_planner'

set :log_level, :debug

set :pty, true

set :linked_files, %w{config/mongoid.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 5

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 16]
set :puma_workers, 0
set :puma_init_active_record, true
set :puma_preload_app, true

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      rvm = '~/.rvm/bin/rvm 2.1.2 do'
      execute "cd /var/applications/travel_planner/current;RAILS_ENV=production #{rvm} bundle exec rake db:migrate"

      execute "if [ \"$( ps -A | grep ruby )\" ]; then killall -9 ruby; fi", pty: true
      [3000, 3001].each do |port|
        execute "cd /var/applications/travel_planner/current; #{rvm} bundle exec puma -p #{port} -e production -d"
      end
    end
  end

  after :publishing, :restart

end
