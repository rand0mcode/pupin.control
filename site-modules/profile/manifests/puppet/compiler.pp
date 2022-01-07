# Class: profile::puppet::compiler
#
#
class profile::puppet::compiler (
  String $puppetdb_host,
  String $control_repo,
){
  include git

  class { 'r10k':
    sources => {
      puppet => {
        remote         => $control_repo,
        basedir        => '/etc/puppetlabs/code/environments',
        prefix         => false,
        generate_types => true,
      },
    },
  }

  class { 'puppetdb::master::config':
    puppetdb_server => $puppetdb_host,
  }
}
