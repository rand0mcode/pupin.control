# Class: profile::database::oracle
#
#
# @param preinstall_pkg
#   url of the rpm for preinstallation dependencies
#
class profile::database::oracle (
  Stdlib::HTTPSUrl $preinstall_pkg = 'https://yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64/getPackage/oracle-database-preinstall-19c-1.0-2.el8.x86_64.rpm',
) {
  package { $preinstall_pkg:
    ensure => 'installed',
  }
}
