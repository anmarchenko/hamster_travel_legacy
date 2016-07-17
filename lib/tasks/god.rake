namespace :god do
  task :start do
    sh('god', '-c', 'lib/god/resque.god')
    sh('god', 'load', 'lib/god/resque_scheduler.god')
    sh('tail', '-f', '/dev/null')
  end
end
