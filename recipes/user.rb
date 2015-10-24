#
# Cookbook Name:: aerospike-cluster
# Recipe:: user
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
# Note: used when node['aerospike']['install_method']  == 'tarball',
# node['aerospike']['install_method']  == 'package' auto install
# aerospike service user/group
#
# WARNING:
# User setup by this recipe may not provide a unique
# user/group id across nodes and could create problem
# of non-unique next available user id for User
# management cookbook.
#
# It is advised to use a User management recipe instead
# for Production systems.
#

group node['aerospike']['group'] do
  system true
  action :create
  only_if { node['aerospike']['setup_user'] }
end

user node['aerospike']['user'] do
  system true
  shell '/bin/false'
  gid node['aerospike']['group']
  action :create
  only_if { node['aerospike']['setup_user'] }
end
