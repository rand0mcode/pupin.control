# Class: role::monitoring::elasticsearch
#
#
class role::monitoring::elasticsearch {
  include profile::base
  include profile::monitoring::elastic::search
}
