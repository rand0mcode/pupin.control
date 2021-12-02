# Class: profile::monitoring::prometheus::server
#
#
class profile::monitoring::prometheus::server {
  class { 'prometheus::server':
    version        => '2.30.1',
    extra_options  => '--web.enable-admin-api',
    scrape_configs => [
      {
        'job_name'        => 'prometheus',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '10s',
        'static_configs'  => [
        {
          'targets' => [
            'localhost:9090'
          ],
          'labels'  =>
            {
              'alias' => 'Prometheus'
            }
          }
          ]
      },
      {
        'job_name'          => 'node-exporter',
        'scrape_interval'   => '10s',
        'scrape_timeout'    => '10s',
        'scheme'            => 'https',
        'tls_config'        => {
          'ca_file'   => '/etc/prometheus/puppet_ca.pem',
          'cert_file' => "/etc/prometheus/puppet_${trusted['certname']}.crt",
          'key_file'  => "/etc/prometheus/puppet_${trusted['certname']}.key"
        },
        'consul_sd_configs' => [
          {
            'server'   => 'localhost:8500',
            'services' => ['node-exporter'],
            'scheme'   => 'http'
          }
        ]
      },
      {
        'job_name'          => 'consul-metrics',
        'scrape_interval'   => '10s',
        'scrape_timeout'    => '10s',
        'scheme'            => 'https',
        'metrics_path'      => '/v1/agent/metrics',
        'params'            => {
          'format' => [
            'prometheus',
          ],
        },
        'tls_config'        => {
          'ca_file'   => '/etc/prometheus/puppet_ca.pem',
          'cert_file' => "/etc/prometheus/puppet_${trusted['certname']}.crt",
          'key_file'  => "/etc/prometheus/puppet_${trusted['certname']}.key"
        },
        'consul_sd_configs' => [
          {
            'server'   => 'localhost:8500',
            'services' => ['consul-metrics'],
            'scheme'   => 'http'
          }
        ]
      }
    ],
  }

  file { "/etc/prometheus/${trusted['certname']}.key":
    ensure  => 'file',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0400',
    source  => "/etc/puppetlabs/puppet/ssl/private_keys/${trusted['certname']}.pem",
    before  => Class['prometheus::config'],
    require => Class['prometheus::install'],
    notify  => Class['prometheus::run_service'],
  }

  file { "/etc/prometheus/puppet_${trusted['certname']}.crt":
    ensure  => 'file',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0400',
    source  => "/etc/puppetlabs/puppet/ssl/certs/${trusted['certname']}.pem",
    before  => Class['prometheus::config'],
    require => Class['prometheus::install'],
    notify  => Class['prometheus::run_service'],
  }

  file { '/etc/prometheus/puppet_ca.pem':
    ensure  => 'file',
    owner   => 'prometheus',
    group   => 'prometheus',
    mode    => '0400',
    source  => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    before  => Class['prometheus::config'],
    require => Class['prometheus::install'],
    notify  => Class['prometheus::run_service'],
  }
}
