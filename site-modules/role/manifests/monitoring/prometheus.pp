# Class: role::monitoring::prometheus
#
#
class role::monitoring::prometheus {
  include profile::monitoring::prometheus::server
  include profile::monitoring::prometheus::node_exporter
}
