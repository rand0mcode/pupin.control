# Class: profile::monitoring::elastic::repo
#
#
class profile::monitoring::elastic::repo (
  Integer $major_version = 8,
){
  # elastic repo does not like to serve rpms over IPv6
  augeas { 'yum.conf_ip_resolve':
    incl    => '/etc/yum.conf',
    lens    => 'Yum.lns',
    context => '/files/etc/yum.conf/main/',
    changes => ' set ip_resolve 4',
  }

  class { 'elastic_stack::repo':
    version => $major_version,
  }
}
