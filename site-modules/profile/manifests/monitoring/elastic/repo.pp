# Class: profile::monitoring::elastic::repo
#
#
class profile::monitoring::elastic::repo (
  Integer $major_version = 8,
){
  class { 'elastic_stack::repo':
    version => $major_version,
  }
}
