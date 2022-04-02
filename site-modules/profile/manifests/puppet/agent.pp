# Class: profile::puppet::agent
#
#
class profile::puppet::agent (
  String  $version          = 'present',
  Boolean $manage_services  = true,
  Boolean $manage_repo      = true,
  Boolean $manage_pki_dir   = true,
  Array   $managed_services = ['puppet'],
  String  $collection       = 'puppet7',
){
  class { 'puppet_agent':
    package_version => $version,
    service_names   => $managed_services,
    collection      => $collection,
    manage_repo     => $manage_repo,
    manage_pki_dir  => $manage_pki_dir,
  }
}
