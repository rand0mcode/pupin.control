# Class: profile::monitoring::elastic::search
#
#
class profile::monitoring::elastic::search {
  contain elastic_stack::repo

  firewall { '100 allow elastic access':
    dport   => [9200, 9300],
    proto   => 'tcp',
    iniface => 'ens10',
    action  => 'accept',
  }

  contain elasticsearch
}
