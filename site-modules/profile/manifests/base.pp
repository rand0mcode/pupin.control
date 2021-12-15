# Class: profile::base
#
#
class profile::base {
  # install locale package
  # on macos the locale is transfered over the ssh connection which can be confusing
  package { 'glibc-langpack-de':
    ensure => installed
  }

  # remove own hostname from /etc/hosts
  # terraform / cloud providers set this often to 127.0.0.1 / ::1 which can be confusing
  # will ne two runs if ipv4 and ipv6 is delcared seperatly
  host { $facts['networking']['fqdn']:
    ensure => absent,
  }

  include profile::puppet::agent
  include profile::monitoring::prometheus::node_exporter
}
