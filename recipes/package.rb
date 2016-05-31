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

case node['aerospike']['package_url']
when 'auto'
  case node['aerospike']['install_edition']
  when 'community'
    package_url = value_for_platform(
      'ubuntu' => {
        '~> 14.04' => "http://aerospike.com/download/server/#{node['aerospike']['version']}/artifact/ubuntu14",
        'default' => "http://aerospike.com/download/server/#{node['aerospike']['version']}/artifact/ubuntu12"
      },
      'debian' => { 'default' => "http://aerospike.com/download/server/#{node['aerospike']['version']}/artifact/debian#{node['platform_version']}" },
      %w(amazon centos redhat) => { 'default' => "http://aerospike.com/download/server/#{node['aerospike']['version']}/artifact/#{node['aerospike']['package_suffix']}" }
    )
  when 'enterprise'
    package_url = value_for_platform(
      'ubuntu' => {
        '~> 14.04' => "http://www.aerospike.com/enterprise/download/server/#{node['aerospike']['version']}/artifact/ubuntu14",
        'default' => "http://www.aerospike.com/enterprise/download/server/#{node['aerospike']['version']}/artifact/ubuntu12"
      },
      'debian' => { 'default' => "http://www.aerospike.com/enterprise/download/server/#{node['aerospike']['version']}/artifact/debian#{node['platform_version']}" },
      %w(amazon centos redhat) => { 'default' => "http://www.aerospike.com/enterprise/download/server/#{node['aerospike']['version']}/artifact/#{node['aerospike']['package_suffix']}" }
    )
  else
    raise "invalid aerospike edition, valid are 'community, enterprise'"
  end
else
  package_url = node['aerospike']['package_url']
end

package_file = ::File.join(node['aerospike']['parent_dir'], "aerospike-server-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']}-#{node['aerospike']['package_suffix']}.tgz")
package_checksum = package_sha256sum(node['aerospike']['install_edition'], node['aerospike']['version'], node['aerospike']['package_suffix']) if node['aerospike']['checksum_verify']

# download tarball
remote_file "Download #{package_file}" do
  source package_url
  checksum package_checksum if node['aerospike']['checksum_verify']
  headers('Authorization' => "Basic #{Base64.encode64("#{node['aerospike']['enterprise']['username']}:#{node['aerospike']['enterprise']['password']}").delete("\n")}") if node['aerospike']['install_edition'] == 'enterprise'
  owner node['aerospike']['user']
  group node['aerospike']['group']
  not_if { ::File.exist?(::File.join(node['aerospike']['source_dir'], 'asinstall')) }
end

# extract tarball
execute 'extract_aerospike_package' do
  user node['aerospike']['user']
  group node['aerospike']['group']
  umask node['aerospike']['umask']
  cwd node['aerospike']['parent_dir']
  command "tar xzf #{package_file}"
  creates ::File.join(node['aerospike']['source_dir'], 'asinstall')
end

remote_file "Delete #{package_file}" do
  action :delete
end

server_package_file = case node['platform']
                      when 'redhat', 'amazon', 'fedora', 'centos'
                        ::File.join(node['aerospike']['source_dir'], "aerospike-server-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']}-1.#{node['aerospike']['package_suffix']}.#{node['kernel']['machine']}.rpm")
                      when 'ubuntu', 'debian'
                        ::File.join(node['aerospike']['source_dir'], "aerospike-server-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']}.#{node['aerospike']['package_suffix']}.#{node['kernel']['machine']}.deb")
                      else
                        raise "unknown platform #{node['platform']}"
                      end

# Tools package could be with a different number. Example with node['aerospike']['version']='3.8.2.3':
# - aerospike-server-community-3.8.2.3-1.el7.x86_64.rpm
# - aerospike-tools-3.8.2-1.el7.x86_64.rpm
package_version = node['aerospike']['version'].split('.')[0..2].join('.')
tools_package_file = case node['platform']
                     when 'redhat', 'amazon', 'fedora', 'centos'
                       ::File.join(node['aerospike']['source_dir'], "aerospike-tools-#{package_version}-1.#{node['aerospike']['package_suffix']}.#{node['kernel']['machine']}.rpm")
                     when 'ubuntu', 'debian'
                       ::File.join(node['aerospike']['source_dir'], "aerospike-tools-#{package_version}.#{node['aerospike']['package_suffix']}.#{node['kernel']['machine']}.deb")
                     else
                       raise "unknown platform #{node['platform']}"
                     end

package server_package_file do
  source server_package_file
  provider Chef::Provider::Package::Dpkg if node['platform_family'] == 'debian'
end

package tools_package_file do
  source tools_package_file
  provider Chef::Provider::Package::Dpkg if node['platform_family'] == 'debian'
end
