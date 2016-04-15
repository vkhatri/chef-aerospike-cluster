#
# Cookbook Name:: aerospike-cluster
# Recipe:: install
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

raise "invalid value for node attribute node['aerospike']['install_method'], valid are 'tarball package'" unless %w(tarball package).include?(node['aerospike']['install_method'])

raise "invalid value for node attribute node['aerospike']['install_edition'], valid are 'community enterprise'" unless %w(community enterprise).include?(node['aerospike']['install_edition'])

if node['aerospike']['install_method'] == 'enterprise'
  raise "missing aerospike enterprise user, require attribute node['aerospike']['enterprise']['username']" unless node['aerospike']['enterprise']['username']
  raise "missing aerospike enterprise password, require attribute 'node['aerospike']['enterprise']['password']'" unless node['aerospike']['enterprise']['password']
end

include_recipe 'aerospike-cluster::dependency'

directory node['aerospike']['parent_dir'] do
  owner node['aerospike']['user']
  group node['aerospike']['group']
  mode node['aerospike']['mode']
  recursive true
end

include_recipe "aerospike-cluster::#{node['aerospike']['install_method']}"

include_recipe 'aerospike-cluster::amc'
