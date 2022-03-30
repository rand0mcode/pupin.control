# Class: profile::puppetdb
#
#
class profile::puppet::db {
  include puppetdb

  firewall { '100 allow https access':
    dport  => [443, 8081],
    proto  => 'tcp',
    action => 'accept',
  }
}
