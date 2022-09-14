# Class: role::monitoring::icinga
#
#
class role::monitoring::icinga {
  include profile::base
  include profile::nginx
  include profile::monitoring::icinga::server
}
