# Class: profile::monitoring::prometheus::node_exporter
#
#
class profile::monitoring::prometheus::node_exporter (
  String $version = '1.3.0'
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

  nginx::resource::server { 'node_exporter':
    listen_ip         => $facts['networking']['interfaces']['ens10']['ip'],
    ipv6_enable       => false,
    server_name       => [$trusted['certname']],
    listen_port       => 9100,
    ssl_port          => 9100,
    proxy             => 'http://127.0.0.1:9100',
    ssl               => true,
    ssl_redirect      => false,
    ssl_key           => "/etc/nginx/puppet_${trusted['certname']}.key",
    ssl_cert          => "/etc/nginx/puppet_${trusted['certname']}.crt",
    ssl_crl           => '/etc/nginx/puppet_crl.pem',
    ssl_client_cert   => '/etc/nginx/puppet_ca.pem',
    ssl_protocols     => 'TLSv1.2',
    ssl_verify_client => 'on',
  }
}
