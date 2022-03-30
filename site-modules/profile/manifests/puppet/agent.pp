# Class: profile::puppet::agent
#
#
class profile::puppet::agent {
  # make sure puppet service is always running
  service { 'puppet':
    ensure => 'running'
  }
}
