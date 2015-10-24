default['aerospike']['config_attribute'] = 'config'

default['aerospike']['config']['service']['user'] = 'root'
default['aerospike']['config']['service']['group'] = 'root'
default['aerospike']['config']['service']['paxos-single-replica-limit'] = 1
default['aerospike']['config']['service']['pidfile'] = '/var/run/aerospike/asd.pid'
default['aerospike']['config']['service']['service-threads'] = 8
default['aerospike']['config']['service']['transaction-queues'] = 8
default['aerospike']['config']['service']['transaction-threads-per-queue'] = 8
default['aerospike']['config']['service']['proto-fd-max'] = 15_000

config_log_file = "file #{node['aerospike']['log_file']}"
default['aerospike']['config']['logging'][config_log_file]['context'] = 'any info'

default['aerospike']['config']['network']['service']['address'] = 'any'
default['aerospike']['config']['network']['service']['port'] = 3000
# cluster configuration
default['aerospike']['config']['network']['heartbeat']['mode'] = 'mesh'
default['aerospike']['config']['network']['heartbeat']['address'] = node['ipaddress']
default['aerospike']['config']['network']['heartbeat']['port'] = 3302
default['aerospike']['config']['network']['heartbeat']['mesh-seed-address-port'] = ["#{node['ipaddress']} #{node['aerospike']['config']['network']['heartbeat']['port']}"]
default['aerospike']['config']['network']['heartbeat']['interval'] = 150
default['aerospike']['config']['network']['heartbeat']['timeout'] = 10

default['aerospike']['config']['network']['fabric']['port'] = 3001
default['aerospike']['config']['network']['info']['port'] = 3003

default['aerospike']['config']['namespace']['test']['replication-factor'] = 1
default['aerospike']['config']['namespace']['test']['memory-size'] = '2M'
default['aerospike']['config']['namespace']['test']['default-ttl'] = '1h'
default['aerospike']['config']['namespace']['test']['storage-engine'] = 'memory'
# default['aerospike']['config']['namespace']['test']['storage-engine device']['scheduler-mode'] = 'noop'
# default['aerospike']['config']['namespace']['test']['storage-engine device']['write-block-size'] = '128K'
