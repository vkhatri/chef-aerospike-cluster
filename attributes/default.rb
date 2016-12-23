default['aerospike']['version']['server'] = '3.10.1.1'
default['aerospike']['version']['tools'] = '3.10.2'
default['aerospike']['version']['amc'] = '3.6.13'

default['aerospike']['tarball_purge'] = false

default['aerospike']['install_method'] = 'tarball' # options: tarball
default['aerospike']['install_edition'] = 'community' # options: community, enterprise

default['aerospike']['enterprise']['username'] = nil
default['aerospike']['enterprise']['password'] = nil

default['aerospike']['packages'] = %w()
default['aerospike']['cookbook'] = 'aerospike-cluster'

default['aerospike']['user']          = 'aerospike'
default['aerospike']['group']         = 'aerospike'
default['aerospike']['setup_user']    = true # for tarball install

default['aerospike']['conf_dir']      = '/etc/aerospike'
default['aerospike']['conf_file']     = ::File.join(node['aerospike']['conf_dir'], 'aerospike.conf')
default['aerospike']['log_dir']       = '/var/log/aerospike'
default['aerospike']['work_dir']      = '/opt/aerospike'

# source install directory locations
default['aerospike']['parent_dir'] = '/usr/local/aerospike'

default['aerospike']['tarball_url'] = 'auto'
default['aerospike']['server_package_url'] = 'auto'
default['aerospike']['tools_package_url'] = 'auto'
default['aerospike']['package_suffix'] = value_for_platform(
  'ubuntu' => { '~> 14.04' => 'ubuntu14.04', 'default' => 'ubuntu12.04' },
  'debian' => { 'default' => "debian#{node['platform_version']}" },
  %w(amazon centos redhat) => { '~> 7.0' => 'el7', 'default' => 'el6' }
)

default['aerospike']['service_action'] = [:enable, :start]
default['aerospike']['notify_restart'] = true
default['aerospike']['umask'] = '0022'
default['aerospike']['mode']  = '0755'

default['aerospike']['enable_test_namespace'] = true

default['aerospike']['chef']['search'] = "role:aerospike-server AND chef_environment:#{node.chef_environment}"
default['aerospike']['checksum_verify'] = true
