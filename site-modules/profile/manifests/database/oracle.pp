# Class: profile::database::oracle
#
#
# @param preinstall_pkg
#   url of the rpm for preinstallation dependencies
#
# @param database_name
# @param install_path
# @param database_pkg
# @param database_ver
# @param database_dwnld_auth_param
# @param oracle_version
# @param os_rel
# @param os_arc
# @param preinstall_name
# @param preinstall_path
# @param preinstall_ver
#
class profile::database::oracle (
  String[1] $oracle_version            = '19c',
  String[1] $os_rel                    = $facts['os']['release']['major'],
  String[1] $os_arc                    = $facts['os']['architecture'],

  String[1] $preinstall_name           = "oracle-database-preinstall-${oracle_version}",
  String[1] $preinstall_ver            = '1.0-2',

  String[1] $database_name             = "oracle-database-ee-${oracle_version}",
  String[1] $database_ver              = '1.0-1',
  String[1] $database_dwnld_auth_param = '1659431446_06ded485875bb130e211bf89d77982f7',

  Stdlib::HTTPSUrl $preinstall_path    = "https://yum.oracle.com/repo/OracleLinux/OL${os_rel}/appstream/${os_arc}/getPackage",
  Stdlib::HTTPSUrl $install_path       = "https://download.oracle.com/otn/linux/oracle${oracle_version}/oracle-database-ee-${oracle_version}-${database_ver}.ol${os_rel}.${os_arc}.rpm?AuthParam=${database_dwnld_auth_param}",
  String[1] $preinstall_pkg            = "${preinstall_name}-${preinstall_ver}.el${os_rel}.${os_arc}.rpm",
  String[1] $database_pkg              = "${database_name}-${database_ver}.${os_arc}.rpm",
) {
  package { $preinstall_name:
    ensure => 'installed',
    source => "${preinstall_path}/${preinstall_pkg}",
  }

  # package { $install_name:
  #   ensure => 'installed',
  #   source => "${install_path}/${database_pkg}",
  # }

  swap_file::files { '8GB Swap':
    ensure       => present,
    swapfile     => '/var/swap.8gb',
    swapfilesize => '8GB',
  }

# /etc/init.d/oracledb_ORCLCDB-19c configure
# service oracledb_ORCLCDB-19c start
}
