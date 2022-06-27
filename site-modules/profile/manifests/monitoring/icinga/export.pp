# Class: profile::monitoring::icinga::export
#
#
class profile::monitoring::icinga::export (
  Array            $host_template,
  Boolean          $enable_flapping,
  Boolean          $export_endpoint,
  Boolean          $is_main,
  String           $check_command,
  String           $parent_zone,
  String           $target_zone,
  String           $node_type,
  Hash             $vars             = {},
  String           $address4         = $facts['networking']['ip'],
  Optional[String] $address6         = $facts['networking']['ip6'],
  String           $host_name        = $facts['networking']['fqdn'],
  String           $endpoint_name    = $facts['networking']['fqdn'],
) {
  unless $is_main {
    if $export_endpoint {
      $exported_vars = merge($vars, { 'client_endpoint' => $endpoint_name })
    } else {
      $exported_vars = $vars
    }

    @@icinga2::object::host { $host_name:
      address         => $address4,
      address6        => $address6,
      check_command   => $check_command,
      enable_flapping => $enable_flapping,
      host_name       => $host_name,
      import          => $host_template,
      vars            => $exported_vars,
      zone            => $parent_zone,
      target          => "/etc/icinga2/zones.d/${target_zone}/${host_name}.conf",
      tag             => [$node_type, $parent_zone],
    }

    if $export_endpoint {
      @@icinga2::object::endpoint { $host_name:
        endpoint_name => $host_name,
        host          => $address,
        tag           => [$node_type, $parent_zone],
      }

      @@::icinga2::object::zone { $host_name:
        endpoints => [$endpoint_name,],
        parent    => $parent_zone,
        tag       => [$node_type, $parent_zone],
      }
    }
  }
}
