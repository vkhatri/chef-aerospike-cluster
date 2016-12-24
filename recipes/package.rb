#
# Cookbook Name:: aerospike-cluster
# Recipe:: package
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

case node['aerospike']['server_package_url']
when 'auto'
  case node['aerospike']['install_edition']
  when 'community'
    server_package_url = value_for_platform(
      'ubuntu' => {
        '~> 14.04' => "http://aerospike.com/download/server/#{node['aerospike']['version']['server']}/artifact/ubuntu14",
        'default' => "http://aerospike.com/download/server/#{node['aerospike']['version']['server']}/artifact/ubuntu12"
      },
      'debian' => { 'default' => "http://aerospike.com/download/server/#{node['aerospike']['version']['server']}/artifact/debian#{node['platform_version']}" },
      %w(amazon centos redhat) => { 'default' => "http://aerospike.com/download/server/#{node['aerospike']['version']['server']}/artifact/#{node['aerospike']['package_suffix']}" }
    )

  when 'enterprise'
    server_package_url = value_for_platform(
      'ubuntu' => {
        '~> 14.04' => "http://www.aerospike.com/enterprise/download/server/#{node['aerospike']['version']['server']}/artifact/ubuntu14",
        'default' => "http://www.aerospike.com/enterprise/download/server/#{node['aerospike']['version']['server']}/artifact/ubuntu12"
      },
      'debian' => { 'default' => "http://www.aerospike.com/enterprise/download/server/#{node['aerospike']['version']['server']}/artifact/debian#{node['platform_version']}" },
      %w(amazon centos redhat) => { 'default' => "http://www.aerospike.com/enterprise/download/server/#{node['aerospike']['version']['server']}/artifact/#{node['aerospike']['package_suffix']}" }
    )

  else
    raise "invalid aerospike edition, valid are 'community, enterprise'"
  end
else
  server_package_url = node['aerospike']['server_package_url']
  tools_package_url = node['aerospike']['tools_package_url']
end

tools_package_url = value_for_platform(
  'ubuntu' => {
    '~> 14.04' => "http://aerospike.com/download/tools/#{node['aerospike']['version']['tools']}/artifact/ubuntu14",
    'default' => "http://aerospike.com/download/tools/#{node['aerospike']['version']['tools']}/artifact/ubuntu12"
  },
  'debian' => { 'default' => "http://aerospike.com/download/tools/#{node['aerospike']['version']['tools']}/artifact/debian#{node['platform_version']}" },
  %w(amazon centos redhat) => { 'default' => "http://aerospike.com/download/tools/#{node['aerospike']['version']['tools']}/artifact/#{node['aerospike']['package_suffix']}" }
)

server_package_file = ::File.join(node['aerospike']['parent_dir'], "aerospike-server-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']['server']}-#{node['aerospike']['package_suffix']}.tgz")
tools_package_file = ::File.join(node['aerospike']['parent_dir'], "aerospike-tools-#{node['aerospike']['version']['tools']}-#{node['aerospike']['package_suffix']}.tgz")

server_package_checksum = package_sha256sum(node['aerospike']['install_edition'], node['aerospike']['version']['server'], node['aerospike']['package_suffix']) if node['aerospike']['checksum_verify']
tools_package_checksum = tools_sha256sum(node['aerospike']['install_edition'], node['aerospike']['version']['tools'], node['aerospike']['package_suffix']) if node['aerospike']['checksum_verify']

# download tarball
remote_file 'download_server_package_file' do
  path server_package_file
  source server_package_url
  checksum server_package_checksum if node['aerospike']['checksum_verify']
  headers('Authorization' => "Basic #{Base64.encode64("#{node['aerospike']['enterprise']['username']}:#{node['aerospike']['enterprise']['password']}").delete("\n")}") if node['aerospike']['install_edition'] == 'enterprise'
  owner node['aerospike']['user']
  group node['aerospike']['group']
  not_if { ::File.exist?(::File.join(node['aerospike']['server_source_dir'], 'asinstall')) }
end

remote_file 'download_tools_package_file' do
  path tools_package_file
  source tools_package_url
  checksum tools_package_checksum if node['aerospike']['checksum_verify']
  headers('Authorization' => "Basic #{Base64.encode64("#{node['aerospike']['enterprise']['username']}:#{node['aerospike']['enterprise']['password']}").delete("\n")}") if node['aerospike']['install_edition'] == 'enterprise'
  owner node['aerospike']['user']
  group node['aerospike']['group']
  not_if { ::File.exist?(::File.join(node['aerospike']['tools_source_dir'], 'asinstall')) }
end

# extract tarball
execute 'extract_server_package_file' do
  user node['aerospike']['user']
  group node['aerospike']['group']
  umask node['aerospike']['umask']
  cwd node['aerospike']['parent_dir']
  command "tar xzf #{server_package_file}"
  creates ::File.join(node['aerospike']['server_source_dir'], 'asinstall')
end

execute 'extract_tools_aerospike_package' do
  user node['aerospike']['user']
  group node['aerospike']['group']
  umask node['aerospike']['umask']
  cwd node['aerospike']['parent_dir']
  command "tar xzf #{tools_package_file}"
  creates ::File.join(node['aerospike']['tools_source_dir'], 'asinstall')
end

# delete tarball
remote_file 'delete_server_package_file' do
  path server_package_file
  action :delete
end

remote_file 'delete_tools_package_file' do
  path tools_package_file
  action :delete
end

server_package_file = case node['platform']
                      when 'redhat', 'amazon', 'fedora', 'centos'
                        ::File.join(node['aerospike']['server_source_dir'], "aerospike-server-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']['server']}-1.#{node['aerospike']['package_suffix']}.#{node['kernel']['machine']}.rpm")
                      when 'ubuntu', 'debian'
                        ::File.join(node['aerospike']['server_source_dir'], "aerospike-server-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']['server']}.#{node['aerospike']['package_suffix']}.#{node['kernel']['machine']}.deb")
                      else
                        raise "unknown platform #{node['platform']}"
                      end

tools_package_file = case node['platform']
                     when 'redhat', 'amazon', 'fedora', 'centos'
                       ::File.join(node['aerospike']['tools_source_dir'], "aerospike-tools-#{node['aerospike']['version']['tools']}-1.#{node['aerospike']['package_suffix']}.#{node['kernel']['machine']}.rpm")
                     when 'ubuntu', 'debian'
                       ::File.join(node['aerospike']['tools_source_dir'], "aerospike-tools-#{node['aerospike']['version']['tools']}.#{node['aerospike']['package_suffix']}.#{node['kernel']['machine']}.deb")
                     else
                       raise "unknown platform #{node['platform']}"
                     end

package 'install_server_package_file' do
  source server_package_file
  provider Chef::Provider::Package::Dpkg if node['platform_family'] == 'debian'
  notifies :restart, 'service[aerospike]' if node['aerospike']['notify_restart']
end

package 'install_tools_package_file' do
  source tools_package_file
  provider Chef::Provider::Package::Dpkg if node['platform_family'] == 'debian'
  notifies :restart, 'service[aerospike]' if node['aerospike']['notify_restart']
end
