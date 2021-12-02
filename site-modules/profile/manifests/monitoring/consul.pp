# Class: profile::monitoring::consul
#
#
class profile::monitoring::consul {
  include consul

  file { "/etc/consul.d/${trusted['certname']}.pem":
    ensure  => 'file',
    owner   => 'consul',
    group   => 'consul',
    mode    => '0400',
    source  => "/etc/puppetlabs/puppet/ssl/private_keys/${trusted['certname']}.pem",
    notify  => Class['consul::reload_service'],
    require => Class['consul::config'],
  }
}
