# Class: role::monitoring::prometheus
#
#
class role::monitoring::prometheus {
  include profile::base
  include profile::nginx
  include profile::monitoring::prometheus::server
}
