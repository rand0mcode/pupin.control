# Class: role::monitoring::kibana
#
#
class role::monitoring::kibana {
  include profile::base
  include profile::nginx
  include profile::monitoring::elastic::kibana
}
