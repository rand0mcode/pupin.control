# Class: profile::monitoring::icinga::server
#
#
class profile::monitoring::icinga::server (
  Boolean $import_customer_hostgroups = true,
  Boolean $use_exported_resources     = true,
  Boolean $use_authoritative_zones    = true,
  Hash $defaults                      = {},
  Hash $objects                       = {},
  Hash $zones_d                       = {},
){
  include icinga2
  ensure_resource('package', 'nagios-plugins-all', {'ensure' => 'latest' })

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
    create_resources('file', $zones_d)
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

  if $use_exported_resources {
    ### Collectors
    Icinga2::Object::Endpoint <<| |>> { }
    Icinga2::Object::Host     <<| |>> { }
    Icinga2::Object::Zone     <<| |>> { }
  }
}
