# Class: profile::add
#
#
# @param packages
#   additional packages to install
#
# @param files
#   additional files/directories to deploy
#
class profile::add (
  Hash $packages = {},
  Hash $files    = {},
) {
  $packages.each |String $package, Hash $settings| {
    package { $package:
      * => $settings,
    }
  }

  $files.each |String $file, Hash $settings| {
    file { $file:
      * => $settings,
    }
  }
}
