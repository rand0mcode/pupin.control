# Class: profile::puppet::compiler
#
#
class profile::puppet::compiler (
  String $control_repo,
  String $r10k_version,
  Array[String[1]] $r10k_purge,
  Optional[Stdlib::Host] $puppetdb_host = undef,
){
  include git

  firewall { '100 allow puppet access':
    dport  => [8140],
    proto  => 'tcp',
    action => 'accept',
  }

  class { 'r10k':
    remote          => $control_repo,
    version         => $r10k_version,
    deploy_settings => {
      purge_levels    => $r10k_purge,
      generate_types  => true,
      purge_allowlist => ['.resource_types'],
    }
  }

  cron { 'update_puppet_envs':
    ensure  => present,
    command => '/opt/puppetlabs/puppet/bin/r10k deploy environment -m -v > /var/log/puppetlabs/last_r10k_cron_run.log 2>&1',
    minute  => '*/10',
  }

  if $puppetdb_host =~ Undef {
    class { 'puppetdb::master::config': }
  } else {
    class { 'puppetdb::master::config':
      puppetdb_server => $puppetdb_host,
    }
  }
}
