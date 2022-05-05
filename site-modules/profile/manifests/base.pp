# Class: profile::base
#
#
class profile::base (
  Boolean $enable_prometheus = false,
  Boolean $enable_filebeat   = false,
){
  # trust puppetca systemwide
  ca_cert::ca { 'PuppetCA':
    ensure => 'trusted',
    source => 'file:///etc/puppetlabs/puppet/ssl/certs/ca.pem',
  }

  if $facts['os']['family'] == 'RedHat' { include profile::epel }

  include profile::add
  include profile::puppet::agent

  # manage prometheus node exporter + nginx reverse proxy
  if $enable_prometheus { include profile::monitoring::prometheus::node_exporter }
  if $enable_filebeat   {
    include profile::monitoring::elastic::repo
    include profile::monitoring::elastic::filebeat
  }
}
