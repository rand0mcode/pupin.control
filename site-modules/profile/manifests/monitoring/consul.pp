# Class: profile::monitoring::consul
#
#
class profile::monitoring::consul {
  file { '/opt/consul':
    ensure => 'directory',
  }

  package { 'unzip':
    ensure => 'installed'
  }

  include consul

  # copy puppet key into consul dir
  file { "/opt/consul/${trusted['certname']}.pem":
    ensure  => 'file',
    owner   => 'consul',
    group   => 'consul',
    mode    => '0400',
    source  => "/etc/puppetlabs/puppet/ssl/private_keys/${trusted['certname']}.pem",
    notify  => Class['consul::reload_service'],
    require => Class['consul::config'],
  }
}
