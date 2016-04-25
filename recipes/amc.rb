#
# Cookbook Name:: aerospike-cluster
# Recipe:: amc
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

package_suffix = value_for_platform_family(
  'rhel' => '-el5',
  'debian' => '.all'
)

package_url_suffix = value_for_platform(
  'ubuntu' => { 'default' => 'ubuntu12' },
  'debian' => { 'default' => 'debian6' },
  %w(amazon centos redhat) => { 'default' => 'el6' }
)

package_type = value_for_platform_family(
  'rhel' => 'rpm',
  'debian' => 'deb'
)

case node['aerospike']['amc']['package_url']
when 'auto'
  case node['aerospike']['install_edition']
  when 'community'
    package_url = "http://www.aerospike.com/download/amc/#{node['aerospike']['amc']['version']}/artifact/#{package_url_suffix}"
  when 'enterprise'
    package_url = "http://#{node['aerospike']['enterprise']['username']}:#{node['aerospike']['enterprise']['password']}@www.aerospike.com/enterprise/download/amc/#{node['aerospike']['amc']['version']}/artifact/#{package_url_suffix}"
  else
    raise "invalid aerospike edition, valid are 'community, enterprise'"
  end
else
  package_url = node['aerospike']['amc']['package_url']
end

package_checksum = amc_package_sha256sum(node['aerospike']['install_edition'], node['aerospike']['amc']['version'], package_url_suffix) if node['aerospike']['checksum_verify']
package_file = ::File.join(node['aerospike']['parent_dir'], "aerospike-amc-#{node['aerospike']['install_edition']}-#{node['aerospike']['amc']['version']}#{package_suffix}.#{node['kernel']['machine']}.#{package_type}")

# download tarball
if node['aerospike']['install_edition'] == 'enterprise'
  # temporary fix for issue - https://github.com/vkhatri/chef-aerospike-cluster/issues/8
  execute "download #{package_file}" do
    user node['aerospike']['user']
    group node['aerospike']['group']
    umask node['aerospike']['umask']
    cwd node['aerospike']['parent_dir']
    command "curl --verbose --location --output #{package_file} --user #{node['aerospike']['enterprise']['username']}:#{node['aerospike']['enterprise']['password']} #{package_url}"
    not_if { ::File.exist?(package_file) }
  end
else
  remote_file package_file do
    source package_url
    checksum package_checksum if node['aerospike']['checksum_verify']
    owner node['aerospike']['user']
    group node['aerospike']['group']
  end
end

node['aerospike']['amc']['packages'].each do |p|
  package p
end

package "aerospike-amc-#{node['aerospike']['install_edition']}-#{node['aerospike']['amc']['version']}#{package_suffix}" do
  source package_file
  provider Chef::Provider::Package::Dpkg if node['platform_family'] == 'debian'
end

template ::File.join(node['aerospike']['amc']['conf_dir'], 'gunicorn_config.py') do
  source 'gunicorn_config.py.erb'
  variables('config' => node['aerospike']['amc']['gunicorn_config'])
  notifies :restart, 'service[amc]' if node['aerospike']['notify_restart']
end

template ::File.join(node['aerospike']['amc']['conf_dir'], 'amc.cfg') do
  source 'amc.cfg.erb'
  notifies :restart, 'service[amc]' if node['aerospike']['notify_restart']
end

service 'amc' do
  action node['aerospike']['amc']['service_action']
end
