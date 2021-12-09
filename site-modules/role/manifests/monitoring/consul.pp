# Class: role::monitoring::consul
#
#
class role::monitoring::consul {
  include profile::base
  include profile::nginx
  include profile::monitoring::consul::server
  include profile::monitoring::prometheus::node_exporter
}
