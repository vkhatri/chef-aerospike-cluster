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

raise 'cookbook only support aerospike community edition tarball installation' if node['aerospike']['install_edition'] != 'community'

tarball_url = if node['aerospike']['tarball_url'] == 'auto'
                "http://www.aerospike.com/download/server/#{node['aerospike']['version']['server']}/artifact/tgz"
              else
                node['aerospike']['tarball_url']
              end

tarball_file = ::File.join(node['aerospike']['parent_dir'], "aerospike-server-community-#{node['aerospike']['version']['server']}.tar.gz")
tarball_checksum = tarball_sha256sum(node['aerospike']['install_edition'], node['aerospike']['version']['server']) if node['aerospike']['checksum_verify']

[
  node['aerospike']['server_source_dir']
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
  only_if { ::File.exist?('/etc/init.d/aerospike') && !File.exist?(node['aerospike']['server_source_dir']) }
end

# download tarball
remote_file 'download_tarball_file' do
  path tarball_file
  source tarball_url
  checksum tarball_checksum if node['aerospike']['checksum_verify']
  owner node['aerospike']['user']
  group node['aerospike']['group']
  not_if { ::File.exist?(::File.join(node['aerospike']['server_source_dir'], 'aerospike-server', 'bin', 'aerospike')) }
end

# extract tarball
execute 'extract_aerospike_tarball' do
  user node['aerospike']['user']
  group node['aerospike']['group']
  umask node['aerospike']['umask']
  cwd node['aerospike']['parent_dir']
  command "tar xzf #{tarball_file} -C #{node['aerospike']['server_source_dir']}"
  creates ::File.join(node['aerospike']['server_source_dir'], 'aerospike-server', 'bin', 'aerospike')
end

remote_file 'delete_tarball_file' do
  path tarball_file
  action :delete
end

link node['aerospike']['install_dir'] do
  to ::File.join(node['aerospike']['server_source_dir'], 'aerospike-server')
  notifies :restart, 'service[aerospike]' if node['aerospike']['notify_restart']
  action :create
end

# sysv init file
template '/etc/init.d/aerospike' do
  cookbook node['aerospike']['cookbook']
  source 'initd.erb'
  owner 'root'
  group 'root'
  mode 0o750
  notifies :restart, 'service[aerospike]', :delayed if node['aerospike']['notify_restart']
end

# purge older versions
ruby_block 'purge-old-tarball' do
  block do
    require 'fileutils'
    installed_versions = Dir.entries(node['aerospike']['parent_dir']).reject { |a| a !~ /^aerospike-/ }.sort
    old_versions = installed_versions - ["aerospike-#{node['aerospike']['version']['server']}"]

    old_versions.each do |v|
      v = ::File.join(node['aerospike']['parent_dir'], v)
      FileUtils.rm_rf Dir.glob(v)
      puts "deleted older aerospike tarball archive #{v}"
      Chef::Log.warn("deleted older aerospike tarball archive #{v}")
    end
  end
  only_if { node['aerospike']['tarball_purge'] }
end
