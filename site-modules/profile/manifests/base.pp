# Class: profile::base
#
#
class profile::base {
  package { 'glibc-langpack-de':
    ensure => installed
  }

  host { 'remove default 127.0.0.1 fqdn entries':
    ensure       => absent,
    name         => $facts['networking']['fqdn'],
    host_aliases => $facts['networking']['hostname'],
    ip           => '127.0.0.1',
  }

  host { 'remove default ::1 fqdn entries':
    ensure       => absent,
    name         => $facts['networking']['fqdn'],
    host_aliases => $facts['networking']['hostname'],
    ip           => '::1',
  }
}
