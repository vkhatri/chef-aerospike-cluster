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
    package_url = "http://www.aerospike.com/download/amc/#{node['aerospike']['version']['amc']}/artifact/#{package_url_suffix}"
  when 'enterprise'
    package_url = "http://www.aerospike.com/enterprise/download/amc/#{node['aerospike']['version']['amc']}/artifact/#{package_url_suffix}"
  else
    raise "invalid aerospike edition, valid are 'community, enterprise'"
  end
else
  package_url = node['aerospike']['amc']['package_url']
end

package_checksum = amc_package_sha256sum(node['aerospike']['install_edition'], node['aerospike']['version']['amc'], package_url_suffix) if node['aerospike']['checksum_verify']
package_file = ::File.join(node['aerospike']['parent_dir'], "aerospike-amc-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']['amc']}#{package_suffix}.#{node['kernel']['machine']}.#{package_type}")

# download rpm
remote_file 'download_amc_package_file' do
  path package_file
  source package_url
  checksum package_checksum if node['aerospike']['checksum_verify']
  headers('Authorization' => "Basic #{Base64.encode64("#{node['aerospike']['enterprise']['username']}:#{node['aerospike']['enterprise']['password']}").delete("\n")}") if node['aerospike']['install_edition'] == 'enterprise'
  owner node['aerospike']['user']
  group node['aerospike']['group']
end

node['aerospike']['amc']['packages'].each do |p|
  package p
end

package 'install_amc_package' do
  name "aerospike-amc-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']['amc']}#{package_suffix}"
  source package_file
  provider Chef::Provider::Package::Dpkg if node['platform_family'] == 'debian'
  notifies :restart, 'service[amc]' if node['aerospike']['notify_restart']
end

template 'gunicorn_config.py' do
  path ::File.join(node['aerospike']['amc']['conf_dir'], 'gunicorn_config.py')
  source 'gunicorn_config.py.erb'
  variables('config' => node['aerospike']['amc']['gunicorn_config'])
  notifies :restart, 'service[amc]' if node['aerospike']['notify_restart']
end

template 'amc.cfg' do
  path ::File.join(node['aerospike']['amc']['conf_dir'], 'amc.cfg')
  source 'amc.cfg.erb'
  notifies :restart, 'service[amc]' if node['aerospike']['notify_restart']
end

service 'amc' do
  action node['aerospike']['amc']['service_action']
end
