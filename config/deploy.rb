# config valid only for Capistrano 3.1

lock '3.2.1'

set :application, 'travel-planner'

set :repo_url, 'git@github.com:altmer/travel-planner.git'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/applications/travel_planner'

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      rvm = '~/.rvm/bin/rvm 2.1.2 do'
      execute "if [ \"$( ps -A | grep ruby )\" ]; then killall -9 ruby; fi", pty: true
      execute "cd /var/applications/travel_planner/current && #{rvm} bundle"
      execute "cp /var/applications/config/mongoid.yml /var/applications/travel_planner/current/config/mongoid.yml"
      execute "cp /var/applications/config/secrets.yml /var/applications/travel_planner/current/config/secrets.yml"
      execute "cd /var/applications/travel_planner/current;RAILS_ENV=production #{rvm} bundle exec rake assets:precompile"
      execute "cd /var/applications/travel_planner/current;RAILS_ENV=production #{rvm} bundle exec rake db:migrate"
    end
  end

  after :publishing, :restart

end
