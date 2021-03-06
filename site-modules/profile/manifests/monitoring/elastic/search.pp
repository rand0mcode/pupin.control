# Class: profile::monitoring::elastic::search
#
#
class profile::monitoring::elastic::search {
  firewall { '100 allow elastic access':
    dport   => [9200, 9300],
    proto   => 'tcp',
    action  => 'accept',
    iniface => 'ens10',
  }

  contain elasticsearch

  file { '/etc/elasticsearch/certs/puppet.cert.pem':
    ensure => file,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0440',
    source => "/etc/puppetlabs/puppet/ssl/certs/${facts['networking']['fqdn']}.pem",
    before => Class['elasticsearch::service'],
  }

  file { '/etc/elasticsearch/certs/puppet.ca.pem':
    ensure => file,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0440',
    source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    before => Class['elasticsearch::service'],
  }

  file { '/etc/elasticsearch/certs/puppet.key.pem':
    ensure => file,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0400',
    source => "/etc/puppetlabs/puppet/ssl/private_keys/${facts['networking']['fqdn']}.pem",
    before => Class['elasticsearch::service'],
  }
}
