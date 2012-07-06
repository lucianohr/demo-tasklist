# RAILS_ENV=production bundle exec unicorn_rails -p 2011 -c config/unicorn.rb -D
# rails_env = ENV['RAILS_ENV'] || 'production'
APP_ROOT = '/home/luciano/development/deploy_apps/demo-tasklist' #File.expand_path(File.dirname(File.dirname(FILE)))

# if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
#   begin
#     rvm_path = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
#     rvm_lib_path = File.join(rvm_path, 'lib')
#     $LOAD_PATH.unshift rvm_lib_path
#     require 'rvm'
#     RVM.use_from_path! APP_ROOT
#   rescue LoadError
#     raise "RVM ruby lib is currently unavailable."
#   end
# end

ENV['BUNDLE_GEMFILE'] = APP_ROOT + '/Gemfile'
require 'bundler/setup'

worker_processes 4
working_directory APP_ROOT

preload_app true

timeout 30

# used for nginx to communicate
# it will send request to here
listen "/tmp/unicorn.sock", :backlog => 64

pid "/tmp/unicorn.pid"

stderr_path APP_ROOT + "/log/unicorn.stderr.log"
stdout_path APP_ROOT + "/log/unicorn.stdout.log"

##
# When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
# immediately start loading up a new version of itself (loaded with a new
# version of our app). When this new Unicorn is completely loaded
# it will begin spawning workers. The first worker spawned will check to
# see if an .oldbin pidfile exists. If so, this means we've just booted up
# a new Unicorn and need to tell the old one that it can now die. To do so
# we send it a QUIT.
#
# Using this method we get 0 downtime deploys.
before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!

  old_pid = APP_ROOT + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Old master alerady dead"
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end