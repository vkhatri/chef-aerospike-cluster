#
# Cookbook Name:: aerospike-cluster
# Recipe:: tarball
#
# Copyright 2015, Virender Khatri
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['aerospike']['install_edition']
when 'community'
  if node['aerospike']['tarball_url'] == 'auto'
    tarball_url = "http://www.aerospike.com/download/server/#{node['aerospike']['version']}/artifact/tgz"
  else
    tarball_url = node['aerospike']['tarball_url']
  end
  tarball_file = ::File.join(node['aerospike']['parent_dir'], "aerospike-server-community-#{node['aerospike']['version']}.tar.gz")
when 'enterprise'
  fail 'cookbook does not support aerospike enterprise edition installation'
else
  fail 'cookbook only support aerospike community edition installation'
end

tarball_checksum = tarball_sha256sum(node['aerospike']['install_edition'], node['aerospike']['version'])

include_recipe 'aerospike-cluster::user'

[node['aerospike']['parent_dir'],
 node['aerospike']['source_dir']
].each do |dir|
  directory dir do
    owner node['aerospike']['user']
    group node['aerospike']['group']
    mode node['aerospike']['mode']
    recursive true
  end
end

# stop aerospike service if running for upgrade
service 'aerospike' do
  service_name 'aerospike'
  action :stop
  only_if { ::File.exist?('/etc/init.d/aerospike') && !File.exist?(node['aerospike']['source_dir']) }
end

# download tarball
remote_file tarball_file do
  source tarball_url
  checksum tarball_checksum
  owner node['aerospike']['user']
  group node['aerospike']['group']
  not_if { ::File.exist?(::File.join(node['aerospike']['source_dir'], 'aerospike-server', 'bin', 'aerospike')) }
end

# extract tarball
execute 'extract_aerospike_tarball' do
  user node['aerospike']['user']
  group node['aerospike']['group']
  umask node['aerospike']['umask']
  cwd node['aerospike']['parent_dir']
  command "tar xzf #{tarball_file} -C #{node['aerospike']['source_dir']}"
  creates ::File.join(node['aerospike']['source_dir'], 'aerospike-server', 'bin', 'aerospike')
end

remote_file tarball_file do
  action :delete
end

link node['aerospike']['install_dir'] do
  to ::File.join(node['aerospike']['source_dir'], 'aerospike-server')
  action :create
end

# sysv init file
template '/etc/init.d/aerospike' do
  cookbook node['aerospike']['cookbook']
  source 'initd.erb'
  owner 'root'
  group 'root'
  mode 0750
  notifies :restart, 'service[aerospike]', :delayed if node['aerospike']['notify_restart']
end

# purge older versions
ruby_block 'purge-old-tarball' do
  block do
    require 'fileutils'
    installed_versions = Dir.entries(node['aerospike']['parent_dir']).reject { |a| a !~ /^aerospike-/ }.sort
    old_versions = installed_versions - ["aerospike-#{node['aerospike']['version']}"]

    old_versions.each do |v|
      v = ::File.join(node['aerospike']['parent_dir'], v)
      FileUtils.rm_rf Dir.glob(v)
      puts "deleted older aerospike tarball archive #{v}"
      Chef::Log.warn("deleted older aerospike tarball archive #{v}")
    end
  end
  only_if { node['aerospike']['tarball_purge'] }
end
