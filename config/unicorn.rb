preload_app true
worker_processes Integer(ENV['UNICORN_WORKER_PROCESSES'] || 4)
timeout Integer(ENV['UNICORN_TIMEOUT'] || 30)
listen ENV['PORT'], backlog: Integer(ENV['UNICORN_BACKLOG'] || 16)

before_fork do |server, worker|

  Signal.trap 'TERM' do
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

end

after_fork do |server, worker|

  Signal.trap 'TERM' do
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection

end
