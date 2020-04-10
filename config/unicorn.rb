worker_processes ENV.fetch('UNICORN_WORKERS', 4).to_i

working_directory "/var/www/deploy/corona-vk"
listen "0.0.0.0:3000", :tcp_nopush => true

timeout ENV.fetch('UNICORN_WORKER_TIMEOUT', 64).to_i

pid "/var/www/deploy/corona-vk/unicorn.pid"

stderr_path "/var/www/deploy/corona-vk/log/unicorn.stderr.log"
stdout_path "/var/www/deploy/corona-vk/log/unicorn.stdout.log"
preload_app true

GC.respond_to?(:copy_on_write_friendly=) and
GC.copy_on_write_friendly = true

check_client_connection false

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "/var/www/deploy/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  sleep 1
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end