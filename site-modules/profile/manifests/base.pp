# Class: profile::base
#
#
# @param enable_prometheus
#   toggle to activate prometheus profiles
#
# @param enable_filebeat
#   toggle to activate filebeat profiles
#
# @param enable_metricbeat
#   toggle to activate metricbeat profiles
#
# @param enable_heartbeat
#   toggle to activate heartbeat profiles
#
# @param enable_auditbeat
#   toggle to activate auditbeat profiles
#
# @param enable_icinga
#   toggle to activate icinga2 profiles
#
class profile::base (
  Boolean $enable_prometheus = false,
  Boolean $enable_filebeat   = false,
  Boolean $enable_metricbeat = false,
  Boolean $enable_heartbeat  = false,
  Boolean $enable_auditbeat  = false,
  Boolean $enable_icinga     = false,
) {
  # trust puppetca systemwide
  ca_cert::ca { 'PuppetCA':
    ensure => 'trusted',
    source => 'file:///etc/puppetlabs/puppet/ssl/certs/ca.pem',
  }

  if $facts['os']['family'] == 'RedHat' { include profile::epel }

  include profile::add
  include profile::puppet::agent
  include profile::monitoring::elastic::repo

  # manage prometheus node exporter + nginx reverse proxy
  if $enable_prometheus {
    include profile::monitoring::prometheus::node_exporter
  }

  if $enable_filebeat {
    include profile::monitoring::elastic::repo
    include profile::monitoring::elastic::filebeat
  }

  if $enable_metricbeat {
    include profile::monitoring::elastic::repo
    include profile::monitoring::elastic::metricbeat
  }

  if $enable_heartbeat {
    include profile::monitoring::elastic::repo
    include profile::monitoring::elastic::heartbeat
  }

  if $enable_auditbeat {
    include profile::monitoring::elastic::repo
    include profile::monitoring::elastic::auditbeat
  }

  if $enable_icinga {
    include profile::monitoring::icinga::export
  }
}
