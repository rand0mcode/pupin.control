# Class: profile::add
#
#
class profile::add (
  Hash $packages = {},
  Hash $files    = {},
){
  $packages.each |String $package, Hash $settings| {
    package { $package:
      * => $settings,
    }
  }

  $files.each |String $file, Hash $settings| {
    file { $file:
      * => $settings
    }
  }
}
