# Class: profile::monitoring::elastic::search
#
#
class profile::monitoring::elastic::search {
  contain elastic_stack::repo

  firewall { '100 allow elastic access':
    dport   => [9200],
    proto   => 'tcp',
    iniface => 'ens10',
    action  => 'accept',
  }

  contain elasticsearch

  file { '/etc/elasticsearch/etc/elasticsearch/certs/puppet.cert.pem':
    ensure => file,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    source => "/etc/puppetlabs/puppet/ssl/certs/${facts['networking']['fqdn']}.pem",
    before => Service['elasticsearch'],
  }

  file { '/etc/elasticsearch/etc/elasticsearch/certs/puppet.ca.pem':
    ensure => file,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    before => Service['elasticsearch'],
  }

  file { '/etc/elasticsearch/etc/elasticsearch/certs/puppet.key.pem':
    ensure => file,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0400',
    source => "/etc/puppetlabs/puppet/ssl/private_keys/${facts['networking']['fqdn']}.pem",
    before => Service['elasticsearch'],
  }
}
