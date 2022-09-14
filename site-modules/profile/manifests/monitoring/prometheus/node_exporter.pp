# Class: profile::monitoring::prometheus::node_exporter
#
#
# @param version
#   version to install
#
# @param listen_ip
#   ip adress to listen on
#
# @param consul
#   toggle to use consul
#
class profile::monitoring::prometheus::node_exporter (
  String $version   = '1.3.1',
  String $listen_ip = $facts['networking']['interfaces']['ens10']['ip'],
  Boolean $consul   = false

) {
  firewall { '100 allow prometheus access':
    dport  => [9100],
    proto  => 'tcp',
    action => 'accept',
  }

  class { 'prometheus::node_exporter':
    collectors_enable      => [
      'diskstats','filesystem','meminfo','netdev','netstat','stat','time',
      'interrupts','tcpstat', 'textfile', 'systemd', 'qdisc', 'processes',
      'mountstats', 'logind', 'loadavg', 'entropy', 'edac', 'cpufreq',
      'cpu', 'conntrack', 'arp',
    ],
    extra_options          => "--web.listen-address ${trusted['certname']}:9100",
    version                => $version,
    use_tls_server_config  => true,
    tls_cert_file          => "/etc/node_exporter/puppet_${trusted['certname']}.crt",
    tls_key_file           => "/etc/node_exporter/puppet_${trusted['certname']}.key",
    tls_client_ca_file     => '/etc/node_exporter/puppet_ca.pem',
    manage_service         => false,
    web_config_file        => '/etc/node_exporter/web-config.yml',
    use_http_server_config => false,
    http2_headers          => {
      'X-Frame-Options' => 'something',
    },
    # basic_auth_users       => {
    #   robert1 => '$apr1$N02mpIL9$0y0vvnDsPF4UPhHv/zX9i/',
    #   robert2 => '$apr1$N02mpIL9$0y0vvnDsPF4UPhHv/zX9i/',
    #   robert3 => '$apr1$N02mpIL9$0y0vvnDsPF4UPhHv/zX9i/',
    # },
  }

  file { '/etc/node_exporter':
    ensure => directory,
    group  => 'node-exporter',
  }

  # copy puppet certs into prometheus dir to use them for querying with client_cert
  file { "/etc/node_exporter/puppet_${trusted['certname']}.key":
    ensure => 'file',
    mode   => '0440',
    group  => 'node-exporter',
    source => "/etc/puppetlabs/puppet/ssl/private_keys/${trusted['certname']}.pem",
  }

  file { "/etc/node_exporter/puppet_${trusted['certname']}.crt":
    ensure => 'file',
    mode   => '0440',
    group  => 'node-exporter',
    source => "/etc/puppetlabs/puppet/ssl/certs/${trusted['certname']}.pem",
  }

  file { '/etc/node_exporter/puppet_ca.pem':
    ensure => 'file',
    mode   => '0440',
    group  => 'node-exporter',
    source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  }

  service { 'node_exporter':
    ensure => 'running',
  }

  if $consul {
    # consule server needs no client
    unless $trusted['extensions']['pp_role'] == 'monitoring::consul' {
      include profile::monitoring::consul::client
    }

    consul::service { 'node-exporter':
      checks  => [
        {
          name     => 'node_exporter health check',
          http     => "https://${trusted['certname']}:9100",
          interval => '10s',
          timeout  => '1s'
        },
      ],
      port    => 9100,
      address => $trusted['certname'],
      tags    => ['node-exporter'],
    }
  }
}
