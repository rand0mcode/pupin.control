# Class: profile::monitoring::prometheus::node_exporter
#
#
class profile::monitoring::prometheus::node_exporter (
  String $version   = '1.3.0',
  String $listen_ip = $facts['networking']['interfaces']['ens10']['ip'],
  Boolean $consul   = false

){
  include profile::nginx

  class { 'prometheus::node_exporter':
    collectors_enable => ['diskstats','filesystem','meminfo','netdev','netstat','stat','time',
                          'interrupts','tcpstat', 'textfile', 'systemd', 'qdisc', 'processes',
                          'mountstats', 'logind', 'loadavg', 'entropy', 'edac',
                          'cpufreq', 'cpu', 'conntrack', 'arp'],
    extra_options     => '--web.listen-address 127.0.0.1:9100',
    version           => $version,
  }

  if $facts['os']['selinux']['enabled'] {
    selboolean { 'httpd_can_network_connect':
      value      => 'on',
      persistent => true,
      before     => Nginx::Resource::Server['node_exporter'],
    }

    selboolean { 'httpd_can_network_relay':
      value      => 'on',
      persistent => true,
      before     => Nginx::Resource::Server['node_exporter'],
    }

    selboolean { 'httpd_setrlimit':
      value      => 'on',
      persistent => true,
      before     => Nginx::Resource::Server['node_exporter'],
    }

    selinux::port { 'allow-nginx-9100':
      ensure   => 'present',
      seltype  => 'http_port_t',
      protocol => 'tcp',
      port     => 9100,
      before   => Nginx::Resource::Server['node_exporter'],
    }
  }

  nginx::resource::server { 'node_exporter':
    ipv6_enable       => false,
    listen_ip         => $listen_ip,
    listen_port       => 9100,
    proxy             => 'http://127.0.0.1:9100',
    server_name       => [$trusted['certname']],
    ssl               => true,
    ssl_cert          => "/etc/nginx/puppet_${trusted['certname']}.crt",
    ssl_client_cert   => '/etc/nginx/puppet_ca.pem',
    ssl_crl           => '/etc/nginx/puppet_crl.pem',
    ssl_key           => "/etc/nginx/puppet_${trusted['certname']}.key",
    ssl_port          => 9100,
    ssl_protocols     => 'TLSv1.2',
    ssl_verify_client => 'on',
  }

  firewall { '100 allow prometheus access':
    dport  => [9100],
    proto  => 'tcp',
    action => 'accept',
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
