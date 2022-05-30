# Class: profile::monitoring::prometheus::node_exporter
#
#
class profile::monitoring::prometheus::node_exporter (
  String $version   = '1.3.1',
  String $listen_ip = $facts['networking']['interfaces']['ens10']['ip'],
  Boolean $consul   = false

){
  firewall { '100 allow prometheus access':
    dport  => [9100],
    proto  => 'tcp',
    action => 'accept',
  }

  class { 'prometheus::node_exporter':
    collectors_enable => ['diskstats','filesystem','meminfo','netdev','netstat','stat','time',
                          'interrupts','tcpstat', 'textfile', 'systemd', 'qdisc', 'processes',
                          'mountstats', 'logind', 'loadavg', 'entropy', 'edac',
                          'cpufreq', 'cpu', 'conntrack', 'arp'],
    extra_options     => '--web.listen-address 127.0.0.1:9100',
    version           => $version,
    tls_server_config => {
      cert_file        => "/etc/node_exporter/puppet_${trusted['certname']}.crt",
      key_file         => "/etc/node_exporter/puppet_${trusted['certname']}.key",
      client_ca_file   => '/etc/node_exporter/puppet_ca.pem',
      client_auth_type => 'RequireAndVerifyClientCert'
    }
  }

  # copy puppet certs into prometheus dir to use them for querying with client_cert
  file { "/etc/node_exporter/puppet_${trusted['certname']}.key":
    ensure  => 'file',
    mode    => '0400',
    source  => "/etc/puppetlabs/puppet/ssl/private_keys/${trusted['certname']}.pem",
    before  => Prometheus::Daemon['node_exporter'],
    require => Class['prometheus::node_exporter'],
  }

  file { "/etc/node_exporter/puppet_${trusted['certname']}.crt":
    ensure  => 'file',
    mode    => '0400',
    source  => "/etc/puppetlabs/puppet/ssl/certs/${trusted['certname']}.pem",
    before  => Prometheus::Daemon['node_exporter'],
    require => Class['prometheus::node_exporter'],
  }

  file { '/etc/node_exporter/puppet_ca.pem':
    ensure  => 'file',
    mode    => '0400',
    source  => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    before  => Prometheus::Daemon['node_exporter'],
    require => Class['prometheus::node_exporter'],
  }

  if $consul {
    include profile::monitoring::consul::client

    consul::service { 'node-exporter':
      checks  => [
        {
          name     => 'node_exporter health check',
          http     => 'http://127.0.0.1:9100',
          interval => '10s',
          timeout  => '1s'
        }
      ],
      port    => 9100,
      address => $trusted['certname'],
      tags    => ['node-exporter'],
    }
  }

}
