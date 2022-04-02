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

  # manage puppet agent
  include profile::puppet::agent

  # manage prometheus node exporter + nginx reverse proxy
  if $enable_prometheus { include profile::monitoring::prometheus::node_exporter }
}
