# Class: profile::monitoring::prometheus::server
#
#
class profile::monitoring::prometheus::server {
  include prometheus::server

  # copy puppet certs into prometheus dir to use them for querying with client_cert
  file { "/etc/prometheus/puppet_${trusted['certname']}.key":
    ensure  => 'file',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0400',
    source  => "/etc/puppetlabs/puppet/ssl/private_keys/${trusted['certname']}.pem",
    before  => Class['prometheus::config'],
    require => Class['prometheus::install'],
    notify  => Class['prometheus::run_service'],
  }

  file { "/etc/prometheus/puppet_${trusted['certname']}.crt":
    ensure  => 'file',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0400',
    source  => "/etc/puppetlabs/puppet/ssl/certs/${trusted['certname']}.pem",
    before  => Class['prometheus::config'],
    require => Class['prometheus::install'],
    notify  => Class['prometheus::run_service'],
  }

  file { '/etc/prometheus/puppet_ca.pem':
    ensure  => 'file',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0400',
    source  => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    before  => Class['prometheus::config'],
    require => Class['prometheus::install'],
    notify  => Class['prometheus::run_service'],
  }
}
