# Class: role::monitoring::kibana
#
#
class role::monitoring::kibana {
  include profile::base
  include profile::monitoring::elastic::repo
  include profile::monitoring::elastic::kibana
}
