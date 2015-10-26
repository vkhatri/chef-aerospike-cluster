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

fail "invalid value for node attribute node['aerospike']['install_method'], valid are 'tarball package'" unless %w(tarball package).include?(node['aerospike']['install_method'])

fail "invalid value for node attribute node['aerospike']['install_edition'], valid are 'community'" unless %w(community).include?(node['aerospike']['install_edition'])

include_recipe 'aerospike-cluster::dependency'

include_recipe "aerospike-cluster::#{node['aerospike']['install_method']}"
