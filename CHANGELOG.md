aerospike-cluster CHANGELOG
===========================

This file is used to list changes made in each version of the aerospike-cluster cookbook.
0.1.8 (01/06/2015)
------------------

- [Oleksandr Sakharchuk](https://github.com/pioneerit):
  - Remove cloning resource attributes from prior resource (CHEF-3694)
  - Permanent fix for #8 - remote_file for enterprise edition with authentication
  - After PR #12 attribute `mesh-seed-address-port` not needed.
  - Update cluster.rb recipe for default value and support chef-solo if possible
  - Restart `amc` applicatoin if `aerospike` was restarted
  - test update

0.1.7 (31/05/2015)
------------------

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Add test suit case for multicast mode cluster

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Update `aerospike-cluster::cluster` to ignore `mesh` configuration for `mode: multicast` which cause an error

0.1.6 (26/05/2015)
------------------

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Add RHEL7 support, after [last Aerospike release](http://www.aerospike.com/download/server/notes.html#3.8.2.1)

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Add Ubuntu-14.04 support

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Update kitchen config

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Add integration tests for old (3.6.3) and latest (3.8.2.3)

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Update kitchen test to docker

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Update travis-ci to use docker

0.1.5 (11/05/2016)
------------------

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Fix foodcritic

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Fix a typo with attribure for package_url

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Added user cookbook as dependency

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Fix travis and typo

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Add atrribute to disable cheksum checking

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Added support for amc version attribute

- [Oleksandr Sakharchuk](https://github.com/pioneerit) - Fixed recipes dependencies

0.1.3 (28/12/2015)
------------------

- Blair Hamilton - adding clustering via chef server

- Virender Khatri - #10, fix enable_test_namespace config disable for test namespace

- Virender Khatri - better namespace formatting

- Virender Khatri - fix rubocop #14

0.1.2 (31/10/2015)
------------------

- Virender Khatri - #7, added enterprise edition support

- Virender Khatri - #4, added amc setup

- Virender Khatri - #3, make test namespace setup optional

0.1.1 (26/10/2015)
------------------

- Virender Khatri - #1, added package installation support

0.1.0 (24/10/2015)
------------------

- Virender Khatri - Initial release of aerospike-cluster

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
