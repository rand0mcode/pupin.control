# Class: profile::base
#
#
class profile::base (
  Boolean $enable_prometheus = false,
){
  # install locale package
  # on macos the locale is transfered over the ssh connection which can be confusing
  package { 'glibc-langpack-de':
    ensure => 'installed'
  }

  package { 'dnf-plugins-core':
    ensure => 'installed'
  }

  # remove own hostname from /etc/hosts
  # terraform / cloud providers set this often to 127.0.0.1 / ::1 which can be confusing
  # will ne two runs if ipv4 and ipv6 is delcared seperatly
  host { $facts['networking']['fqdn']:
    ensure => absent,
  }

  if $facts['os']['family'] == 'RedHat' { include epel }

  include profile::puppet::agent

  if $enable_prometheus { include profile::monitoring::prometheus::node_exporter }
}
