# Class: profile::base
#
#
class profile::base {
  package { 'glibc-langpack-de':
    ensure => installed
  }
}
