rails_env = ENV['RAILS_ENV'] || 'development'

threads 1,1
workers 2

bind  "unix:///var/applications/travel_planner/shared/tmp/puma/puma.sock"
pidfile "/var/applications/travel_planner/current/tmp/puma/pid"
state_path "/var/applications/travel_planner/current/tmp/puma/state"

activate_control_app
