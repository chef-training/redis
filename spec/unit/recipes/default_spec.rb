#
# Cookbook Name:: redis
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'redis::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'execute a package repository update' do
      expect(chef_run).to run_execute('apt-get update')
    end

    it 'installs the necessary packages' do
      expect(chef_run).to install_package([ 'build-essential', 'tcl8.5' ])
    end

    it 'downloads the redis archive' do
      expect(chef_run).to create_remote_file('~/redis-2.8.9.tar.gz')
    end

    it 'unpacks the redis archive' do
      resource = chef_run.remote_file('~/redis-2.8.9.tar.gz')
      expect(resource).to notify('execute[tar xzf redis-2.8.9.tar.gz]').to(:run).immediately
    end

    it 'makes redis and installs it' do
      resource = chef_run.execute('tar xzf redis-2.8.9.tar.gz')
      expect(resource).to notify('execute[make && make install]').to(:run).immediately
    end

    it 'installs redis server' do
      resource = chef_run.execute('make && make install')
      expect(resource).to notify('execute[echo -n | ./install_server.sh]').to(:run).immediately
    end

    it 'starts the redis service' do
      expect(chef_run).to start_service('redis_6379')
    end
  end
end
