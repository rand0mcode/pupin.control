# Class: profile::monitoring::elastic::kibana
#
#
class profile::monitoring::elastic::kibana {
  contain elastic_stack::repo
  contain kibana
}
