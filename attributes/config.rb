# http://www.aerospike.com/docs/reference/configuration/#file
default['aerospike']['config_attribute'] = 'config'

# xdr {}
default['aerospike']['config']['xdr'] = {}

# cluster {}
default['aerospike']['config']['cluster'] = {}

# service {}
default['aerospike']['config']['service']['user'] = 'root'
default['aerospike']['config']['service']['group'] = 'root'
default['aerospike']['config']['service']['paxos-single-replica-limit'] = 1
default['aerospike']['config']['service']['pidfile'] = '/var/run/aerospike/asd.pid'
default['aerospike']['config']['service']['service-threads'] = 4
default['aerospike']['config']['service']['transaction-queues'] = 4
default['aerospike']['config']['service']['transaction-threads-per-queue'] = 4
default['aerospike']['config']['service']['proto-fd-max'] = 15_000

# network {}
default['aerospike']['config']['network']['service']['address'] = 'any'
default['aerospike']['config']['network']['service']['port'] = 3000

# heartbeat {}
default['aerospike']['config']['network']['heartbeat']['mode'] = 'mesh'
default['aerospike']['config']['network']['heartbeat']['address'] = node['ipaddress']
default['aerospike']['config']['network']['heartbeat']['port'] = 3002
default['aerospike']['config']['network']['heartbeat']['mesh-seed-address-port'] = ["#{node['ipaddress']} #{node['aerospike']['config']['network']['heartbeat']['port']}"]
default['aerospike']['config']['network']['heartbeat']['interval'] = 150
default['aerospike']['config']['network']['heartbeat']['timeout'] = 10

# fabric {}
default['aerospike']['config']['network']['fabric']['port'] = 3001

# info {}
default['aerospike']['config']['network']['info']['port'] = 3003

# namespace {}
default['aerospike']['config']['namespace']['test']['replication-factor'] = 1
default['aerospike']['config']['namespace']['test']['memory-size'] = '1M'
default['aerospike']['config']['namespace']['test']['default-ttl'] = '1h'
# default['aerospike']['config']['namespace']['test']['single-bin'] = true
# default['aerospike']['config']['namespace']['test']['data-in-index'] = true
# default['aerospike']['config']['namespace']['test']['high-water-memory-pct'] = 60
# default['aerospike']['config']['namespace']['test']['stop-writes-pct'] = 90

# memory storage engine
# default['aerospike']['config']['namespace']['test']['storage-engine'] = 'memory'

# ssd device storage engine
# default['aerospike']['config']['namespace']['test']['storage-engine device']['device'] = %w(/dev/xvdb /dev/xvdc)
# default['aerospike']['config']['namespace']['test']['storage-engine device']['write-block-size'] = '128K'
# default['aerospike']['config']['namespace']['test']['storage-engine device']['scheduler-mode'] = 'noop'

# hdd device storage engine
default['aerospike']['config']['namespace']['test']['storage-engine device']['filesize'] = '4M'

# default['aerospike']['config']['namespace']['test']['storage-engine device']['data-in-memory'] = true
