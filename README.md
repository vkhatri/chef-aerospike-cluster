aerospike-cluster Cookbook
================

[![Cookbook](https://img.shields.io/github/tag/vkhatri/chef-aerospike-cluster.svg)](https://github.com/vkhatri/chef-aerospike-cluster)[![Build Status](https://travis-ci.org/vkhatri/chef-aerospike-cluster.svg?branch=master)](https://travis-ci.org/vkhatri/chef-aerospike-cluster)[![supermarket.chef.io](https://img.shields.io/cookbook/v/aerospike-cluster.svg)](https://supermarket.chef.io/cookbooks/aerospike-cluster)

This is a [Chef] cookbook to manage [Aerospike].

>> For Production environment, always prefer the [most recent release](https://supermarket.chef.io/cookbooks/aerospike-cluster).

### Most Recent Release

```
cookbook 'aerospike-cluster'
```

### From Git

```
cookbook 'aerospike-cluster', github: 'vkhatri/chef-aerospike-cluster'
```

## Repository
```
https://github.com/vkhatri/chef-aerospike-cluster
```

## Supported OS

This cookbook was tested on Amazon Linux & Ubuntu 14.04 and expected to work on other RHEL platforms.
Recently Aerospike added support for systemd tested on CentOS7 and expected to work on rhel7, Debian8 with systemd compatibility.


## Supported Edition

Cookbook supports both Aerospike `Community` and `Enterprise` edition.

>> Note that `Enterprise` edition can only be installed using
`package` install_method.


## Supported Aerospike Version

This cookbook was tested for Aerospike v3.8.2.3. But default is 3.6.3


## TODO

- add `specs`
- manage aerospike `dependencies`, e.g. python-bcrypt etc. if any
- add `role` examples
- add `amc` enterprise edition configuration parameters



## Recipes

- `aerospike-cluster::default` - default recipe (use it for run_list)

- `aerospike-cluster::attributes` - aerospike derived attributes

- `aerospike-cluster::install` - install aerospike

- `aerospike-cluster::user` - setup aerospike user

- `aerospike-cluster::tarball` - aerospike tarball installation

- `aerospike-cluster::package` - aerospike package installation

- `aerospike-cluster::config` - configure aerospike

- `aerospike-cluster::cluster` - uses chef search to derive value for attribute `default['aerospike']['config']['network']['heartbeat']['mesh-seed-address-port']`

- `aerospike-cluster::amc` - install and configure aerospike management console


## Advanced Attributes


* `default['aerospike']['version']` (default: `3.6.3`): aerospike version

* `default['aerospike']['tarball_url']` (default: `auto`): aerospike tarball url

* `default['aerospike']['checksum_verify']` (default: `true`): checking checksum of aerospike and amc tarballs/packages

* `default['aerospike']['notify_restart']` (default: `true`): whether to restart aerospike service on configuration file change

* `default['aerospike']['install_method']` (default: `tarball`): aerospike install method, options: tarball

* `default['aerospike']['install_edition']` (default: `community`): aerospike edition, options: community, enterprise

* `default['aerospike']['tarball_purge']` (default: `false`): whether to purge old tarball versions

* `default['aerospike']['cookbook']` (default: `aerospike-cluster`): whether to purge old tarball versions

* `default['aerospike']['enable_test_namespace']` (default: `true`): whether to add `test` namespace to `aerospike.conf`

* `default['aerospike']['enterprise']['username']` (default: `nil`): aerospike enterprise user name

* `default['aerospike']['enterprise']['password']` (default: `nil`): aerospike enterprise user password

* `default['aerospike']['chef']['search']` (default: `nil`): chef search query to set attribute `default['aerospike']['config']['network']['heartbeat']['mesh-seed-address-port']`, must include recipe `aerospike-cluster::cluster` recipe to run_list

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

>> Note: `aerospike.conf` is dynamically generated and few of the attributes are managed differently, like `default['aerospike']['config']['service']['logging']['file <calculated log file /var/log/aerospike/aerospike.log']['context']`, `default['aerospike']['config']['network']['heartbeat']['mesh-seed-address-port']` and `default['aerospike']['config']['namespace']['test']['storage-engine device']['scheduler-mode']`. Please check out helper method `as_config_generator` for more details.


### Configuration File aerospike.conf service {} Attributes


* `default['aerospike']['config']['service']['user']` (default: `root`): aerospike configuration attribute

* `default['aerospike']['config']['service']['group']` (default: `root`): aerospike configuration attribute

* `default['aerospike']['config']['service']['paxos-single-replica-limit']` (default: `1`): aerospike configuration attribute

* `default['aerospike']['config']['service']['pidfile']` (default: `/var/run/aerospike/asd.pid`): aerospike configuration attribute

* `default['aerospike']['config']['service']['service-threads']` (default: `4`): aerospike configuration attribute

* `default['aerospike']['config']['service']['transaction-queues']` (default: `4`): aerospike configuration attribute

* `default['aerospike']['config']['service']['transaction-threads-per-queue']` (default: `4`): aerospike configuration attribute

* `default['aerospike']['config']['service']['proto-fd-max']` (default: `15000`): aerospike configuration attribute


### Configuration File aerospike.conf logging {} Attributes

* `default['aerospike']['config']['logging']['file config_log_file']['context']` (default: `any info`): aerospike log file context

>> `config_log_file` location is calculated dynamically


### Configuration File aerospike.conf mod-lua {} Attributes

* `default['aerospike']['config']['mod-lua']['user-path']` (default: `/opt/aerospike/usr/udf/lua`): aerospike mod-lua attribute

* `default['aerospike']['config']['mod-lua']['system-path']` (default: `/opt/aerospike/sys/udf/lua`): aerospike mod-lua attribute


### Configuration File aerospike.conf network {} Attributes


* `default['aerospike']['config']['network']['service']['address']` (default: `any`): aerospike configuration attribute

* `default['aerospike']['config']['network']['service']['port']` (default: `3000`): aerospike configuration attribute

* `default['aerospike']['config']['network']['heartbeat']['mode']` (default: `mesh`): aerospike configuration attribute

* `default['aerospike']['config']['network']['heartbeat']['address']` (default: `node['ipaddress']`): aerospike configuration attribute

* `default['aerospike']['config']['network']['heartbeat']['port']` (default: `3002`): aerospike configuration attribute

* `default['aerospike']['config']['network']['heartbeat']['mesh-seed-address-port']` (default: `[]`): aerospike unicast cluster seed ip addresses

>> as `mesh-seed-address-port` accepts multiple values, variable type is set to `Array` and parameter is rendered differently in helper method `as_config_generator`


* `default['aerospike']['config']['network']['heartbeat']['interval']` (default: `150`): aerospike configuration attribute

* `default['aerospike']['config']['network']['heartbeat']['timeout']` (default: `10`): aerospike configuration attribute

* `default['aerospike']['config']['network']['fabric']['port']` (default: `3001`): aerospike configuration attribute

* `default['aerospike']['config']['network']['heartbeat']['info']` (default: `3003`): aerospike configuration attribute


### Configuration File aerospike.conf namespace {} Attributes

>> namespace configuration can be added to `aerospike.conf` configuration file via attribute `default['aerospike']['config']['namespace']['NAMESPACE_NAME']['option'] = value`. By default,  a namespace `test` is added to the configuration. Below are the default options for `test` namespace.

* `default['aerospike']['config']['namespace']['test']['replication-factor']` (default: `1`): aerospike namespace configuration attribute

* `default['aerospike']['config']['namespace']['test']['memory-size']` (default: `1M`): aerospike namespace configuration attribute

* `default['aerospike']['config']['namespace']['test']['default-ttl']` (default: `1h`): aerospike namespace configuration attribute


##### Configure Memory Storage Engine

* `default['aerospike']['config']['namespace']['test']['storage-engine']` (default: `memory`): aerospike namespace configuration attribute


##### Configure SSD Device Storage Engine

* `default['aerospike']['config']['namespace']['test']['storage-engine device']['device']` (default: `['/dev/xvdb', 'dev/xvdc']`): aerospike namespace configuration attribute

* `default['aerospike']['config']['namespace']['test']['storage-engine device']['write-block-size']` (default: `128k`): aerospike namespace configuration attribute

* `default['aerospike']['config']['namespace']['test']['storage-engine device']['data-in-memory']` (default: `true`): aerospike namespace configuration attribute


##### Configure HDD Device Storage Engine

* `default['aerospike']['config']['namespace']['test']['storage-engine device']['file']` (default: `/var/lib/aerospike/test.ns`): aerospike namespace configuration attribute

* `default['aerospike']['config']['namespace']['test']['storage-engine device']['filesize']` (default: `1G`): aerospike namespace configuration attribute

* `default['aerospike']['config']['namespace']['test']['storage-engine device']['scheduler-mode']` (default: `noop`): aerospike namespace configuration attribute

* `default['aerospike']['config']['namespace']['test']['storage-engine device']['data-in-memory']` (default: `true`): aerospike namespace configuration attribute



## AMC Attributes

* `default['aerospike']['amc']['version']` (default: `3.6.3`): amc version

* `default['aerospike']['amc']['conf_dir']` (default: `/etc/amc/config`): amc config directory

* `default['aerospike']['amc']['log_dir']` (default: `/var/log/amc`): amc log directory

* `default['aerospike']['amc']['service_action']` (default: `[:enable, :start]`): amc service resource action

* `default['aerospike']['amc']['packages']` (default: `clculated`): amc packages dependency

* `default['aerospike']['amc']['package_url']` (default: `auto`): amc package url

* `default['aerospike']['amc']['update_interval']` (default: `5`): amc.cfg configuration parameter

* `default['aerospike']['amc']['host']` (default: `node['ipaddress']`): amc gunicorn bind host

* `default['aerospike']['amc']['port']` (default: `8081`): amc gunicorn bind port

* `default['aerospike']['amc']['gunicorn_config']['bind']` (default: `calculated`): amc gunicorn configuration parameter

* `default['aerospike']['amc']['gunicorn_config']['errorlog']` (default: `/var/log/amc/error.log`): amc gunicorn configuration parameter

* `default['aerospike']['amc']['gunicorn_config']['loglevel']` (default: `info`): amc gunicorn configuration parameter

* `default['aerospike']['amc']['gunicorn_config']['workers']` (default: `1`): amc gunicorn configuration parameter

* `default['aerospike']['amc']['gunicorn_config']['timeout']` (default: `150`): amc gunicorn configuration parameter

* `default['aerospike']['amc']['gunicorn_config']['pidfile']` (default: `/tmp/amc.pid`): amc gunicorn configuration parameter

* `default['aerospike']['amc']['gunicorn_config']['proc_name']` (default: `amc`): amc gunicorn configuration parameter

* `default['aerospike']['amc']['gunicorn_config']['chdir']` (default: `/opt/amc/server`): amc gunicorn configuration parameter

* `default['aerospike']['amc']['gunicorn_config']['worker_class']` (default: `eventlet`): amc gunicorn configuration parameter



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
