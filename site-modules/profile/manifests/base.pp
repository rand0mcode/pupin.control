# Class: profile::base
#
#
class profile::base (
  Boolean $enable_prometheus = false,
){
  # first install epel repo
  if $facts['os']['family'] == 'RedHat' { include epel }

  # add additional packages, files, ...
  contain profile::add

  # remove own hostname from /etc/hosts
  # terraform / cloud providers set this often to 127.0.0.1 / ::1 which can be confusing
  # will need two runs if ipv4 and ipv6 is delcared seperatly
  host { 'ipv4 localhost':
    ensure => absent,
    name   => $facts['networking']['fqdn'],
    ip     => '127.0.0.1',
  }

  host { 'ipv6 localhost':
    ensure => absent,
    name   => $facts['networking']['fqdn'],
    ip     => '::1',
  }

  # manage puppet agent
  include profile::puppet::agent

  # manage prometheus node exporter + nginx reverse proxy
  if $enable_prometheus { include profile::monitoring::prometheus::node_exporter }
}
