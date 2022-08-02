# Class: profile::database::oracle
#
#
class profile::database::oracle {
  swap_file::files { '8GB Swap':
    ensure       => present,
    swapfile     => '/var/swap.8gb',
    swapfilesize => '8GB',
  }

  #installation is done with :
  # bolt task run bootstrap::oracle_download_and_install_database_rpm oracle_version=21c auth_param=AUTH_ID -t oracle
}
