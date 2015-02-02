# Class: apache2::conf
#
#   This module manages apache2 configuration file (for Apache 2.4+).
#
#   Tested platforms:
#    - Ubuntu 14.04
#
# Parameters:
# $name:
# 	the name of the configuration file without the .conf extension (ex: charset)
# $activated:
# 	this variable allow to chose if the configuration file should be activated (true) or not (false) (default: true)
#
# $conf_file_template:
#   the configuration file template if any
#
# Actions:
#
#  Installs, configures, and manages apache 2 configuration files.
#
# Requires:
# apache2
#
# Sample Usage:
#
#   apache2::conf { "charset":
#       activated		        => true,
#       conf_file_template  => false
#   }
#
#   apache2::conf { "virtual":
#       activated           => true,
#       conf_file_template  => true
#   }
#
# [Remember: No empty lines between comments and class definition]
define apache2::conf (
  $activated          = true,
  $conf_file_template = false) {
  include 'apache2'

  case $apache2::params::apache_version {
    /(2.2)/ : {
      if ($activated == true) {
        if ($conf_file_template == true) {
          file { "${apache2::params::confd_dir}/${name}.conf":
            ensure  => file,
            owner   => root,
            group   => root,
            content => template("apache2/conf.d/${name}.conf.erb"),
            notify  => Class['apache2::service'],
          }
        }
      } else {
        if ($conf_file_template == true) {
          file { "${apache2::params::confd_dir}/${name}.conf":
            ensure => absent,
            notify => Class['apache2::service'],
          }
        } else {
          fail("The module ${module_name} can't deactivate an Apache [conf.d] file without a template in ${::operatingsystem} ${::lsbdistrelease} (it works starting from Ubuntu 14.04)")
        }
      }
    }
    /(2.4)/ : {
      if ($activated == true) {
        if ($conf_file_template == true) {
          file { "${apache2::params::conf_available_dir}/${name}.conf":
            ensure  => file,
            owner   => root,
            group   => root,
            content => template("apache2/conf.d/${name}.conf.erb"),
            notify  => Class['apache2::service'],
          }
        }

        file { "${apache2::params::conf_enabled_dir}/${name}.conf":
          ensure  => link,
          owner   => root,
          group   => root,
          target  => "${apache2::params::conf_available_dir}/${name}.conf",
          require => File["${apache2::params::conf_available_dir}/${name}.conf"],
          notify  => Class['apache2::service'],
        }
      } else {
        file { "${apache2::params::conf_enabled_dir}/${name}.conf":
          ensure => absent,
          notify => Class['apache2::service'],
        }
        # If the file is made from a template, we remove it
        if ($conf_file_template == true) {
          file { "${apache2::params::conf_available_dir}/${name}.conf":
            ensure  => absent,
            notify  => Class['apache2::service'],
          }
        }
      }
    }
    default         : {
      fail("The ${module_name} module don't support Apache [${apache2::params::apache_version}] version")
    }
  }
}
