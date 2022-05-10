# Class: profile::puppet::ca
#
#
class profile::puppet::ca {
  firewall { '100 allow puppet access':
    dport  => [8140],
    proto  => 'tcp',
    action => 'accept',
  }
}
