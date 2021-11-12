# Class: profile::puppet::compiler
#
#
class profile::puppet::compiler (
  String $puppetdb_host = 'puppetdb.priv.example42.cloud',
  String $control_repo  = 'https://github.com/rand0mcode/pupin.control.git',
){
  include git

  class { 'r10k':
    sources => {
      'puppet' => {
        'remote'  => $control_repo,
        'basedir' => '/etc/puppetlabs/code/environments',
        'prefix'  => false,
      },
    },
  }

  class { 'puppetdb::master::config':
    puppetdb_server => $puppetdb_host,
  }
}
