# Class: profile::base
#
#
class profile::base {
  package { 'glibc-langpack-de':
    ensure => installed
  }

  host { $facts['networking']['fqdn']:
    ensure       => absent,
    host_aliases => $facts['networking']['hostname'],
    ip           => $facts['networking']['interfaces']['ens10']['ip'],
  }
}
