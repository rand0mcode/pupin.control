# Class: profile::nginx
#
#
class profile::nginx {
  include nginx

  # copy puppet certs into nginx dir to use them for vhosts
  file { "/etc/nginx/puppet_${trusted['certname']}.key":
    ensure  => 'file',
    owner   => 'nginx',
    group   => 'nginx',
    mode    => '0400',
    source  => "/etc/puppetlabs/puppet/ssl/private_keys/${trusted['certname']}.pem",
    notify  => Class['nginx::service'],
    require => Class['nginx::config'],
  }

  file { "/etc/nginx/puppet_${trusted['certname']}.crt":
    ensure  => 'file',
    owner   => 'nginx',
    group   => 'nginx',
    mode    => '0400',
    source  => "/etc/puppetlabs/puppet/ssl/certs/${trusted['certname']}.pem",
    notify  => Class['nginx::service'],
    require => Class['nginx::config'],
  }

  file { '/etc/nginx/puppet_crl.pem':
    ensure  => 'file',
    owner   => 'nginx',
    group   => 'nginx',
    mode    => '0400',
    source  => '/etc/puppetlabs/puppet/ssl/crl.pem',
    notify  => Class['nginx::service'],
    require => Class['nginx::config'],
  }

  file { '/etc/nginx/puppet_ca.pem':
    ensure  => 'file',
    owner   => 'nginx',
    group   => 'nginx',
    mode    => '0400',
    source  => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    notify  => Class['nginx::service'],
    require => Class['nginx::config'],
  }
}
