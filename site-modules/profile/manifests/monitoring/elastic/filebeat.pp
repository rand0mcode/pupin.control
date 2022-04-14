# Class: profile::monitoring::elastic::filebeat
#
#
class profile::monitoring::elastic::filebeat {
  contain elastic_stack::repo
  contain filebeat
}
