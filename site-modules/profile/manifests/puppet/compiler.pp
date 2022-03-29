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
        remote  => $control_repo,
        basedir => '/etc/puppetlabs/code/environments',
        prefix  => false,
      },
    },
  }

  cron { 'update_puppet_envs':
    ensure  => present,
    command => '/opt/puppetlabs/puppet/bin/r10k deploy environment -pv > /var/log/puppetlabs/last_r10k_cron_run.log 2>&1',
    minute  => '*/10',
  }

  class { 'puppetdb::master::config':
    puppetdb_server => $puppetdb_host,
  }
}
