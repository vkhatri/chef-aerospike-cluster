# http://www.aerospike.com/docs/reference/configuration
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
default['aerospike']['config']['network']['heartbeat']['interval'] = 150
default['aerospike']['config']['network']['heartbeat']['timeout'] = 10

# fabric {}
default['aerospike']['config']['network']['fabric']['port'] = 3001

# info {}
default['aerospike']['config']['network']['info']['port'] = 3003
