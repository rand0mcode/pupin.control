# Class: role::puppet::aio
#
#
class role::puppet::aio {
  include profile::base
  include profile::puppet::compiler
  include profile::puppet::db
}
