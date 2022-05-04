# Class: profile::yum
#
#
class profile::yum {
  class { 'yum':
    clean_old_kernels => true,
    config_options    => {
      ip_resolve => 4, # download packages over ipv4
    },
  }
}
