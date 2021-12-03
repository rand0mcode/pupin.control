# Class: profile::base
#
#
class profile::base {
  package { 'glibc-langpack-de':
    ensure => installed
  }

  host { $facts['networking']['fqdn']:
    ensure => absent,
  }
}
