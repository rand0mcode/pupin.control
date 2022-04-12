# Class: profile::monitoring::elastic::search
#
#
class profile::monitoring::elastic::search (
  Hash $users = {},
){
  firewall { '100 allow elastic access':
    dport   => [9200, 9300],
    proto   => 'tcp',
    action  => 'accept',
    iniface => 'ens10',
  }

  contain elastic_stack::repo
  contain elasticsearch

  file { '/etc/elasticsearch/certs/puppet.cert.pem':
    ensure => file,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0440',
    source => "/etc/puppetlabs/puppet/ssl/certs/${facts['networking']['fqdn']}.pem",
    before => Service['elasticsearch'],
  }

  file { '/etc/elasticsearch/certs/puppet.ca.pem':
    ensure => file,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0440',
    source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    before => Service['elasticsearch'],
  }

  file { '/etc/elasticsearch/certs/puppet.key.pem':
    ensure => file,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0400',
    source => "/etc/puppetlabs/puppet/ssl/private_keys/${facts['networking']['fqdn']}.pem",
    before => Service['elasticsearch'],
  }

  $users.each |String $user, Hash $settings| {
    elasticsearch::user { $user:
      * => $settings
    }
  }
}
