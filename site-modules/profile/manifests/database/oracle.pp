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

  # set the swap ,forge puppet module petems-swap_file
  class { 'swap_file':
    swapfile     => '/var/swap.1',
    swapfilesize => '8192000000',
  }

  $puppet_download_mnt_point = 'oradb/'

  oradb::installdb { '12.2.0.1_Linux-x86-64':
    version                   => '12.2.0.1',
    file                      => 'V839960-01',
    database_type             => 'EE',
    oracle_base               => '/oracle',
    oracle_home               => '/oracle/product/12.2/db',
    bash_profile              => true,
    user                      => 'oracle',
    group                     => 'dba',
    group_install             => 'oinstall',
    group_oper                => 'oper',
    download_dir              => '/data/install',
    zip_extract               => true,
    puppet_download_mnt_point => $puppet_download_mnt_point,
  }
}
