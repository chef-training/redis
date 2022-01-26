#
# Cookbook:: redis
# Recipe:: default
#
# Copyright:: (c) 2016 The Authors, All Rights Reserved.
#
# Translated Instructions From:
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis
#

execute 'apt-get update'

package 'build-essential'

package 'tcl8.5'

# download http://download.redis.io/releases/redis-2.8.9.tar.gz
remote_file '~/redis-2.8.9.tar.gz' do
  source 'http://download.redis.io/releases/redis-2.8.9.tar.gz'
  notifies :run, 'execute[tar xzf redis-2.8.9.tar.gz]', :immediately
end

# unzip the archive
execute 'tar xzf redis-2.8.9.tar.gz' do
  cwd '/tmp'
  action :nothing
  notifies :run, 'execute[make && make install]', :immediately
end

# Configure the application: make and make install
execute 'make && make install' do
  cwd '/tmp/redis-2.8.9'
  action :nothing
  notifies :run, 'execute[echo -n | ./install_server.sh]', :immediately
end

# Install the Server
execute 'echo -n | ./install_server.sh' do
  cwd '/tmp/redis-2.8.9/utils'
  action :nothing
end

service 'redis_6379' do
  action [ :start ]
  # This is necessary so that the service will not keep reporting as updated
  supports status: true
end
