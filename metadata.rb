name 'aerospike-cluster'
maintainer 'Virender Khatri'
maintainer_email 'vir.khatri@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures aerospike-cluster'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/vkhatri/chef-aerospike-cluster/issues'
source_url 'https://github.com/vkhatri/chef-aerospike-cluster'
version '0.1.7'

%w(ubuntu centos amazon redhat fedora).each do |os|
  supports os
end

recipe 'aerospike-cluster', 'Aerospike installatoin and default installation. Includes repices: attributes, install, config'
recipe 'aerospike-cluster::attributes', 'Aerospike derived attributes'
recipe 'aerospike-cluster::install', 'Install aerospike'
recipe 'aerospike-cluster::user', 'Setup aerospike user'
recipe 'aerospike-cluster::tarball', 'Aerospike tarball installation'
recipe 'aerospike-cluster::package', 'Aerospike package installation'
recipe 'aerospike-cluster::amc', 'Install and configure aerospike management console'
recipe 'aerospike-cluster::config', 'Configure Aerospike'
recipe 'aerospike-cluster::cluster', 'Uses chef search if configured to derive value for attribute `default[\'aerospike\'][\'config\'][\'network\'][\'heartbeat\'][\'mesh-seed-address-port\']`'
