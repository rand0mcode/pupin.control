# Class: profile::monitoring::icinga::server
#
# @param use_exported_resources
# @param use_puppetdb_resources
# @param use_authoritative_zones
# @param defaults
# @param objects
# @param zones_d
class profile::monitoring::icinga::server (
  Boolean $use_exported_resources     = true,
  Boolean $use_puppetdb_resources     = false,
  Boolean $use_authoritative_zones    = true,
  Hash $defaults                      = {},
  Hash $objects                       = {},
  Hash $zones_d                       = {},
) {
  exec { '/usr/bin/yum config-manager --set-enabled powertools': }

  include icinga::repos
  include mysql::server
  include icinga2

  ensure_resource('package', 'nagios-plugins-all', { ensure => 'latest', require => Class['epel'] })

  file { '/etc/icinga2/zones.d':
    ensure  => directory,
    mode    => '0750',
    owner   => 'icinga',
    group   => 'icinga',
    recurse => true,
    purge   => true,
    force   => true,
  }

  if $use_authoritative_zones {
    $zones_d.each |String $zone_d, Hash $settings| {
      file { $zone_d:
        * => $settings,
      }
    }
  }

  $objects.each |String $object_type, Hash $content| {
    $content.each |String $object_name, Hash $object_config| {
      ensure_resource(
        $object_type,
        $object_name,
        deep_merge($defaults[$object_type], $object_config)
      )
    }
  }

  if $use_puppetdb_resources {
    $hosts =  puppetdb_query('resources { type = "Icinga2::Object::Host" and exported = true }')

    $hosts.each |$host| {
      icinga2::object::host { $host['title']:
        * => $host['parameters'],
      }
    }
  }

  if $use_exported_resources {
    ### Collectors
    Icinga2::Object::Endpoint <<| |>> {}
    Icinga2::Object::Host     <<| |>> {}
    Icinga2::Object::Zone     <<| |>> {}
  }
}
