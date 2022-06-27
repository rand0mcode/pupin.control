# Class: profile::monitoring::icinga::load_test
#
#
class profile::monitoring::icinga::load_test {
  Integer[0, 900].each |$x| {
    $host_name = "host_${x}.dummy.local"

    @@icinga2::object::host { $host_name:
      address       => '127.0.0.1',
      check_command => 'hostalive',
      host_name     => $host_name,
      import        => ['generic-host'],
      zone          => 'Main',
      target        => "/etc/icinga2/zones.d/Main/${host_name}.conf",
      tag           => ['dummy','Main'],
    }
  }
}
