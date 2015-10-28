default['aerospike']['amc']['conf_dir'] = '/etc/amc/config'
default['aerospike']['amc']['log_dir'] = '/var/log/amc'

default['aerospike']['amc']['service_action'] = [:enable, :start]

default['aerospike']['amc']['packages'] = value_for_platform_family(
  'debian' => %w(python-dev),
  'rhel' => %w()
)

default['aerospike']['amc']['package_url'] = 'auto'
default['aerospike']['amc']['update_interval'] = 5
default['aerospike']['amc']['port'] = 8081
default['aerospike']['amc']['host'] = node['ipaddress']

default['aerospike']['amc']['gunicorn_config']['bind'] = node['aerospike']['amc']['host'] + ':' + node['aerospike']['amc']['port'].to_s
default['aerospike']['amc']['gunicorn_config']['errorlog'] = '/var/log/amc/error.log'
default['aerospike']['amc']['gunicorn_config']['loglevel'] = 'info'
default['aerospike']['amc']['gunicorn_config']['workers'] = 1
default['aerospike']['amc']['gunicorn_config']['timeout'] = 150
default['aerospike']['amc']['gunicorn_config']['pidfile'] = '/tmp/amc.pid'
default['aerospike']['amc']['gunicorn_config']['proc_name'] = 'amc'
default['aerospike']['amc']['gunicorn_config']['chdir'] = '/opt/amc/server'
default['aerospike']['amc']['gunicorn_config']['worker_class'] = 'eventlet'
