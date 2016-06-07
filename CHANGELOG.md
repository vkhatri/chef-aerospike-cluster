aerospike-cluster CHANGELOG
===========================

This file is used to list changes made in each version of the aerospike-cluster cookbook.

0.1.8 (01/06/2015)
------------------

- [Oleksandr Sakharchuk](https://github.com/pioneerit):
  - Remove cloning resource attributes from prior resource (CHEF-3694)
  - Permanent fix for [#8](https://github.com/vkhatri/chef-aerospike-cluster/issues/8) - remote_file for enterprise edition with authentication
  - After PR [#12](https://github.com/vkhatri/chef-aerospike-cluster/pull/12) attribute `mesh-seed-address-port` not needed.
  - Update cluster.rb recipe for default value and support chef-solo if possible
  - Restart `amc` applicatoin if `aerospike` was restarted
  - test update

0.1.7 (31/05/2015)
------------------

- [Oleksandr Sakharchuk](https://github.com/pioneerit):
  - Add test suit case for multicast mode cluster
  - Update `aerospike-cluster::cluster` to ignore `mesh` configuration for `mode: multicast` which cause an error

0.1.6 (26/05/2015)
------------------

- [Oleksandr Sakharchuk](https://github.com/pioneerit):
  - Add RHEL7 support, after [last Aerospike release](http://www.aerospike.com/download/server/notes.html#3.8.2.1)
  - Add Ubuntu-14.04 support
  - Update kitchen config
  - Add integration tests for old (3.6.3) and latest (3.8.2.3)
  - Update kitchen test to docker
  - Update travis-ci to use docker

0.1.5 (11/05/2016)
------------------

- [Oleksandr Sakharchuk](https://github.com/pioneerit):
  - Fix foodcritic
  - Fix a typo with attribure for package_url
  - Added user cookbook as dependency
  - Fix travis and typo
  - Add atrribute to disable cheksum checking
  - Added support for amc version attribute
  - Fixed recipes dependencies

0.1.3 (28/12/2015)
------------------

- [Blair Hamilton](https://github.com/blairham) - adding clustering via chef server

- [Virender Khatri](https://github.com/vkhatri):
  - #10, fix enable_test_namespace config disable for test namespace
  - better namespace formatting
  - fix rubocop #14

0.1.2 (31/10/2015)
------------------

- [Virender Khatri](https://github.com/vkhatri):
  - #7, added enterprise edition support
  - #4, added amc setup
  - #3, make test namespace setup optional

0.1.1 (26/10/2015)
------------------

- [Virender Khatri](https://github.com/vkhatri) - #1, added package installation support

0.1.0 (24/10/2015)
------------------

- [Virender Khatri](https://github.com/vkhatri) - Initial release of aerospike-cluster

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
