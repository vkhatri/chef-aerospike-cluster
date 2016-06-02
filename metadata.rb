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
