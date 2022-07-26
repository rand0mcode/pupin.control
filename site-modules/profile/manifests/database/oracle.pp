# Class: profile::database::oracle
#
#
# @param preinstall_pkg
#   url of the rpm for preinstallation dependencies
#
# @param preinstall_arc
# @param preinstall_name
# @param preinstall_rel
# @param preinstall_ver
# @param preinstall_path
#
class profile::database::oracle (
  String[1] $preinstall_arc  = $facts['os']['architecture'],
  String[1] $preinstall_name = 'oracle-database-preinstall-19c',
  String[1] $preinstall_rel  = $facts['os']['release']['major'],
  String[1] $preinstall_ver  = '1.0-2',

  Stdlib::HTTPSUrl $preinstall_path = "https://yum.oracle.com/repo/OracleLinux/OL${preinstall_rel}/appstream/${preinstall_arc}/getPackage",
  String[1]        $preinstall_pkg  = "${preinstall_name}-${preinstall_ver}.el${preinstall_rel}.${preinstall_arc}.rpm",
) {
  package { $preinstall_name:
    ensure => 'installed',
    source => "${preinstall_path}/${preinstall_pkg}",
  }
}
