class apache2::params {
  $ensure_mode = $apache2::lastversion ? {
    true    => latest,
    default => present
  }
  info("${module_name} ensure mode = ${ensure_mode}")

  case $::operatingsystem {
    /(Ubuntu|Debian)/ : {
      $service_name        = 'apache2'
      $package_name        = 'apache2-mpm-worker'
      $user                = 'www-data'
      $group               = 'www-data'
      # $ssl_package			= 'apache-ssl'

      $config_dir          = '/etc/apache2'
      $config_file         = "${config_dir}/apache2.conf"
      $ports_file          = "${config_dir}/ports.conf"

      $sites_available_dir = "${config_dir}/sites-available"
      $sites_enabled_dir   = "${config_dir}/sites-enabled"

      $mods_available_dir  = "${config_dir}/mods-available"
      $mods_enabled_dir    = "${config_dir}/mods-enabled"

      $certs_dir           = "${config_dir}/certs"

      $includes_dir        = $apache2::includes_dir ? {
        false   => "${config_dir}/includes",
        default => $apache2::includes_dir,
      }
      case $::lsbdistrelease {
        /(10.04|11.04|12.04)/ : {
          $apache_version       = '2.2'
          $confd_dir            = "${config_dir}/conf.d"

          # MPM configuration
          $mpm_engine           = "mpm_worker"
          $mpm_config_file      = "${config_file}"
        }
        /(14.04)/ : {
          $apache_version       = '2.4'
          $conf_available_dir   = "${config_dir}/conf-available"
          $conf_enabled_dir     = "${config_dir}/conf-enabled"
          $confd_dir            = $conf_enabled_dir # for backward compatibility with Apache 2.2

          # MPM configuration
          $mpm_engine           = "mpm_${::apache2_mpm_type}"
          $mpm_config_file      = "${mods_enabled_dir}/${mpm_engine}.conf"
        }
        default         : {
          fail("The ${module_name} module is not supported on ${::operatingsystem} ${::lsbdistrelease}")
        }
      }

      $mpm_module           = "${mpm_engine}_module"
    }
    default           : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
