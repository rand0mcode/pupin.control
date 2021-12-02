# Class: profile::monitoring::prometheus::node_exporter
#
#
class profile::monitoring::prometheus::node_exporter {
  class { 'prometheus::node_exporter':
    collectors_enable => ['diskstats','filesystem','meminfo','netdev','netstat','stat','time',
                          'interrupts','tcpstat', 'textfile', 'systemd', 'qdisc', 'processes',
                          'mountstats', 'logind', 'loadavg', 'entropy', 'edac',
                          'cpufreq', 'cpu', 'conntrack', 'arp'],
    extra_options     => '--web.listen-address 127.0.0.1:9100',
    version           => '0.18.1',
  }
}
