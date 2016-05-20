# Class: apache2::module
#
#   This module manages apache2 modules.
#
#   Tested platforms:
#    - Ubuntu 14.04
#    - Ubuntu 12.04
#    - Ubuntu 11.04 Natty
#
# Parameters:
# $name:
# 	the name of the module (ex: fcgid)
# $package_name:
# 	the name of the package for the module
# $activated:
# 	this variable allow to chose if the module should be activated (true) or not (false) (default: true)
#
# Actions:
#
#  Installs, configures, and manages apache 2 modules.
#
# Requires:
# apache2
#
# Sample Usage:
#
#   apache2::module { "fcgid":
#       package_name 	=> "libapache2-mod-fcgid",
#       activated		=> true,
#   }
#
# [Remember: No empty lines between comments and class definition]
define apache2::module (
  $package_name       = false,
  $activated          = true,
  $conf_file          = true,
  $conf_file_template = false) {
  include 'apache2'

  if $package_name != false {
    ensure_packages ( $package_name, { 'notify' => Class['apache2::service'], 'require' => Class['apt::update'] } )
  }

  if ($activated == true) {
    file { "${apache2::params::mods_enabled_dir}/${name}.load":
      ensure => link,
      owner  => root,
      group  => root,
      target => "${apache2::params::mods_available_dir}/${name}.load",
      # 		require	=> File ["${apache2::params::mods_available_dir}/${name}.load"],
      notify => Class['apache2::service'],
    }

    if ($conf_file == true) {
      if ($conf_file_template == true) {
        file { "${apache2::params::mods_available_dir}/${name}.conf":
          ensure  => file,
          owner   => root,
          group   => root,
          content => template("apache2/mods-available/${name}.conf.erb"),
          require => File["${apache2::params::mods_enabled_dir}/${name}.load"],
          notify  => Class['apache2::service'],
        }
      }

      file { "${apache2::params::mods_enabled_dir}/${name}.conf":
        ensure  => link,
        owner   => root,
        group   => root,
        target  => "${apache2::params::mods_available_dir}/${name}.conf",
        require => File["${apache2::params::mods_enabled_dir}/${name}.load"],
        notify  => Class['apache2::service'],
      }
    } else {
      file { "${apache2::params::mods_enabled_dir}/${name}.conf":
        ensure => absent,
        notify => Class['apache2::service'],
      }
    }
  } else {
    file { "${apache2::params::mods_enabled_dir}/${name}.load":
      ensure => absent,
      notify => Class['apache2::service'],
    }

    file { "${apache2::params::mods_enabled_dir}/${name}.conf":
      ensure => absent,
      notify => Class['apache2::service'],
    }
  }

}
