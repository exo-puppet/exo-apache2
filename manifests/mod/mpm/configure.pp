class apache2::mod::mpm::configure {
  ####################################
  # Configure the MPM Worker module
  ####################################
  case $apache2::params::apache_version {
    /2.2/ : {
      augeas { 'configure-apache2-mpm-worker-module':
        context => "/files${apache2::params::mpm_config_file}",
        changes => [
          "set IfModule[arg = 'mpm_worker_module']/*[self::directive='StartServers']/arg \"${apache2::start_servers}\"",
          "set IfModule[arg = 'mpm_worker_module']/*[self::directive='MinSpareThreads']/arg \"${apache2::min_spare_threads}\"",
          "set IfModule[arg = 'mpm_worker_module']/*[self::directive='MaxSpareThreads']/arg \"${apache2::max_spare_threads}\"",
          "set IfModule[arg = 'mpm_worker_module']/*[self::directive='ThreadLimit']/arg \"${apache2::thread_limit}\"",
          "set IfModule[arg = 'mpm_worker_module']/*[self::directive='ThreadsPerChild']/arg \"${apache2::thread_per_child}\"",
          "set IfModule[arg = 'mpm_worker_module']/*[self::directive='MaxClients']/arg \"${apache2::max_clients}\"",
          "set IfModule[arg = 'mpm_worker_module']/*[self::directive='MaxRequestsPerChild']/arg \"${apache2::max_requests_per_child}\"",
          ],
        require => [
          Class['apache2::install'],
          Package['augeas-tools']],
        notify  => Class['apache2::service'],
      }
    }
    default : {
      class { "apache2::mod::mpm::common" :
        require => Class['apache2::install'],
        notify  => Class['apache2::service'],
      } ->
      class { "apache2::mod::mpm::${::apache2_mpm_type}" :
        require => Class['apache2::install'],
        notify  => Class['apache2::service'],
      }
    }
  }
}
