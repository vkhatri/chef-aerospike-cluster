#
# Cookbook Name:: aerospike-cluster
# Recipe:: attributes
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

node.default['aerospike']['install_dir'] = ::File.join(node['aerospike']['parent_dir'], 'aerospike')

case node['aerospike']['install_method']
when 'package'
  node.default['aerospike']['source_dir'] = ::File.join(node['aerospike']['parent_dir'], "aerospike-server-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']}-#{node['aerospike']['package_suffix']}")
else
  node.default['aerospike']['source_dir'] = ::File.join(node['aerospike']['parent_dir'], "aerospike-server-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']}-tgz")
end

node.default['aerospike']['bin_dir'] = node['aerospike']['install_method'] == 'package' ? '/usr/bin' : ::File.join(node['aerospike']['install_dir'], 'bin')
node.default['aerospike']['data_dir'] = ::File.join(node['aerospike']['work_dir'], 'data')
node.default['aerospike']['smd_dir'] = ::File.join(node['aerospike']['work_dir'], 'smd')
node.default['aerospike']['log_file'] = ::File.join(node['aerospike']['log_dir'], 'aerospike.log')

# service {}
node.default['aerospike']['config']['service']['work-directory'] = node['aerospike']['work_dir']

# mod-lua {}
node.default['aerospike']['config']['mod-lua']['user-path'] = ::File.join(node['aerospike']['work_dir'], 'usr', 'udf', 'lua')
node.default['aerospike']['config']['mod-lua']['system-path'] = ::File.join(node['aerospike']['work_dir'], 'sys', 'udf', 'lua')

# hdd device storage engine
node.default['aerospike']['config']['namespace']['test']['storage-engine device']['file'] = ::File.join(node['aerospike']['data_dir'], 'test.ns')

# logging ()
config_log_file = "file #{node['aerospike']['log_file']}"
node.default['aerospike']['config']['logging'][config_log_file]['context'] = 'any info'
