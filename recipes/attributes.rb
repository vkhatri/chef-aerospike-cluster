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
node.default['aerospike']['source_dir'] = ::File.join(node['aerospike']['parent_dir'], "aerospike-#{node['aerospike']['version']}")
node.default['aerospike']['home_dir'] = node['aerospike']['install_method'] == 'package' ? '/usr/share/aerospike' : node['aerospike']['install_dir']
node.default['aerospike']['bin_dir'] = ::File.join(node['aerospike']['home_dir'], 'bin')
