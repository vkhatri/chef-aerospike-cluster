aerospike-cluster Cookbook
================

[![Build Status](https://travis-ci.org/vkhatri/chef-aerospike-cluster.svg?branch=master)](https://travis-ci.org/vkhatri/chef-aerospike-cluster)

This is a [Chef] cookbook to manage [Aerospike].


## Repository

https://github.com/vkhatri/chef-aerospike-cluster


## Supported OS

This cookbook was tested on Amazon Linux and expected to work on other RHEL platforms.


## Recipes

- `aerospike-cluster::default` - default recipe (use it for run_list)

- `aerospike-cluster::attributes` - aerospike derived attributes

- `aerospike-cluster::install` - install aerospike

- `aerospike-cluster::user` - setup aerospike user

- `aerospike-cluster::tarball` - aerospike tarball installation

- `aerospike-cluster::package` - aerospike package installation

- `aerospike-cluster::config` - configure aerospike


## Advanced Attributes


* `default['aerospike']['version']` (default: `3.6.3`): aerospike version

* `default['aerospike']['tarball_url']` (default: `auto`): aerospike tarball url

* `default['aerospike']['notify_restart']` (default: `true`): whether to restart aerospike service on configuration file change

* `default['aerospike']['install_method']` (default: `tarball`): aerospike install method, options: tarball

* `default['aerospike']['install_edition']` (default: `community`): aerospike edition, options: community

* `default['aerospike']['tarball_purge']` (default: `false`): whether to purge old tarball versions

* `default['aerospike']['cookbook']` (default: `aerospike-cluster`): whether to purge old tarball versions


## Core Attributes

* `default['aerospike']['user']` (default: `user`): aerospike user name

* `default['aerospike']['group']` (default: `user`): aerospike group name

* `default['aerospike']['setup_user']` (default: `true`): setup aerospike user for tarball install method

* `default['aerospike']['conf_dir']` (default: `/etc/aerospike`): aerospike yaml configuration file directory

* `default['aerospike']['conf_file']` (default: `/etc/aerospike/aerospike.conf`): aerospike configuration file

* `default['aerospike']['log_dir']` (default: `/var/log/aerospike`): aerospike log file directory

* `default['aerospike']['log_file']` (default: `/var/log/aerospike/aerospike.log`): aerospike log file

* `default['aerospike']['data_dir']` (default: `/var/lib/aerospike`): aerospike data directory

* `default['aerospike']['parent_dir']` (default: `/usr/local/aerospike`): aerospike tarball setup directory

* `default['aerospike']['service_action']` (default: `[:enable, :restart]`): aerospike service resource action

* `default['aerospike']['umask']` (default: `0022`): umask for execute resource

* `default['aerospike']['mode']` (default: `0755`): file directory default permission


## Configuration File aerospike.conf Attributes

* `default['aerospike']['config_attribute']` (default: `config`): aerospike configuration node attribute

* `default['aerospike']['config']['service']['user']` (default: `root`): aerospike configuration attribute

...

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests (`rake & rake knife`), ensuring they all pass
6. Write new resource/attribute description to `README.md`
7. Write description about changes to PR
8. Submit a Pull Request using Github


## Copyright & License

Authors:: Virender Khatri and [Contributors]

<pre>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>


[Chef]: https://www.chef.io/
[Aerospike]: http://www.aerospike.com/
[Contributors]: https://github.com/vkhatri/chef-aerospike-cluster/graphs/contributors
