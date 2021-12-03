# Class: role::monitoring::consul
#
#
class role::monitoring::consul {
  include profile::nginx
  include profile::monitoring::consul
}
