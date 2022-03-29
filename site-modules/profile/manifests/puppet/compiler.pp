# Class: profile::puppet::compiler
#
#
class profile::puppet::compiler (
  String $puppetdb_host,
  String $control_repo,
  String $r10k_version,
  Array[String[1]] $r10k_purge,
){
  include git

  class { 'r10k':
    remote          => $control_repo,
    version         => $r10k_version,
    deploy_settings => {
      purge_levels   => $r10k_purge,
      generate_types => true,
    }
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
