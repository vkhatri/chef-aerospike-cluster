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

node.default['aerospike']['server_source_dir'] = case node['aerospike']['install_method']
                                                 when 'package'
                                                   ::File.join(node['aerospike']['parent_dir'], "aerospike-server-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']['server']}-#{node['aerospike']['package_suffix']}")
                                                 else
                                                   ::File.join(node['aerospike']['parent_dir'], "aerospike-server-#{node['aerospike']['install_edition']}-#{node['aerospike']['version']['server']}-tgz")
                                                 end

node.default['aerospike']['tools_source_dir'] = case node['aerospike']['install_method']
                                                when 'package'
                                                  ::File.join(node['aerospike']['parent_dir'], "aerospike-tools-#{node['aerospike']['version']['tools']}-#{node['aerospike']['package_suffix']}")
                                                else
                                                  ::File.join(node['aerospike']['parent_dir'], "aerospike-tools-#{node['aerospike']['version']['tools']}-tgz")
                                                end

node.default['aerospike']['bin_dir'] = node['aerospike']['install_method'] == 'package' ? '/usr/bin' : ::File.join(node['aerospike']['install_dir'], 'bin')
node.default['aerospike']['data_dir'] = ::File.join(node['aerospike']['work_dir'], 'data')
node.default['aerospike']['smd_dir'] = ::File.join(node['aerospike']['work_dir'], 'smd')
node.default['aerospike']['log_file'] = ::File.join(node['aerospike']['log_dir'], 'aerospike.log')

# service {}
node.default['aerospike']['config']['service']['work-directory'] = node['aerospike']['work_dir']

# heartbeat {}
node.default['aerospike']['config']['network']['heartbeat']['port'] = case node['aerospike']['config']['network']['heartbeat']['mode']
                                                                      when 'multicast'
                                                                        9918
                                                                      when 'mesh'
                                                                        3002
                                                                      end
node.default['aerospike']['config']['network']['heartbeat']['address'] = case node['aerospike']['config']['network']['heartbeat']['mode']
                                                                         when 'multicast'
                                                                           '224.2.2.4'
                                                                         when 'mesh'
                                                                           node['ipaddress']
                                                                         end

# mod-lua {}
node.default['aerospike']['config']['mod-lua']['user-path'] = ::File.join(node['aerospike']['work_dir'], 'usr', 'udf', 'lua')
node.default['aerospike']['config']['mod-lua']['system-path'] = ::File.join(node['aerospike']['work_dir'], 'sys', 'udf', 'lua')

# logging ()
config_log_file = "file #{node['aerospike']['log_file']}"
node.default['aerospike']['config']['logging'][config_log_file]['context'] = 'any info'

# enable test namespace by default
if node['aerospike']['enable_test_namespace']
  # hdd device storage engine
  node.default['aerospike']['config']['namespace']['test']['storage-engine device']['file'] = ::File.join(node['aerospike']['data_dir'], 'test.ns')
  node.default['aerospike']['config']['namespace']['test']['replication-factor'] = 1
  node.default['aerospike']['config']['namespace']['test']['memory-size'] = '1M'
  node.default['aerospike']['config']['namespace']['test']['default-ttl'] = '1h'
  # node.default['aerospike']['config']['namespace']['test']['single-bin'] = true
  # node.default['aerospike']['config']['namespace']['test']['data-in-index'] = true
  # node.default['aerospike']['config']['namespace']['test']['high-water-memory-pct'] = 60
  # node.default['aerospike']['config']['namespace']['test']['stop-writes-pct'] = 90

  # memory storage engine
  # node.default['aerospike']['config']['namespace']['test']['storage-engine'] = 'memory'

  # ssd device storage engine
  # node.default['aerospike']['config']['namespace']['test']['storage-engine device']['device'] = %w(/dev/xvdb /dev/xvdc)
  # node.default['aerospike']['config']['namespace']['test']['storage-engine device']['write-block-size'] = '128K'
  # node.default['aerospike']['config']['namespace']['test']['storage-engine device']['scheduler-mode'] = 'noop'

  # hdd device storage engine
  node.default['aerospike']['config']['namespace']['test']['storage-engine device']['filesize'] = '4M'

  # node.default['aerospike']['config']['namespace']['test']['storage-engine device']['data-in-memory'] = true
end
