#
# Cookbook Name:: aerospike-cluster
# Recipe:: config
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

[
  node['aerospike']['conf_dir'],
  node['aerospike']['log_dir'],
  node['aerospike']['work_dir'],
  node['aerospike']['data_dir'],
  node['aerospike']['smd_dir'],
  node['aerospike']['config']['mod-lua']['user-path'],
  node['aerospike']['config']['mod-lua']['system-path'],
  node['aerospike']['config']['service']['work-directory']
].uniq.each do |d|
  directory d do
    owner node['aerospike']['user']
    group node['aerospike']['group']
    mode node['aerospike']['mode']
    recursive true
  end
end

config = node['aerospike'][node['aerospike']['config_attribute']]

template node['aerospike']['conf_file'] do
  cookbook node['aerospike']['cookbook']
  source 'aerospike.conf.erb'
  owner node['aerospike']['user']
  group node['aerospike']['group']
  mode 0o644
  variables(:config => config)
  notifies :restart, 'service[aerospike]' if node['aerospike']['notify_restart']
end

service 'aerospike' do
  supports :restart => true, :start => true, :stop => true, :status => true, :reload => false
  action node['aerospike']['service_action']
  case node['platform']
  when 'centos'
    if node['platform_version'].to_f >= 7
      provider Chef::Provider::Service::Systemd
    end
  end
end
