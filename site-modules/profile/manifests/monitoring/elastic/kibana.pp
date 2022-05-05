# Class: profile::monitoring::elastic::kibana
#
#
class profile::monitoring::elastic::kibana {
  contain nginx
  contain kibana
}
