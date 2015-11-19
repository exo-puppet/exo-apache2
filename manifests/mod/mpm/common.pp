class apache2::mod::mpm::common {
  file_line { 'mpm_start_servers' :
    path    => "${apache2::params::mpm_config_file}",
    match   => "StartServers.*[0-9]+",
    after   => "<IfModule ${apache2::params::mpm_module}>",
    line    => "  StartServers             ${apache2::start_servers}",
    require => [
      Class['apache2::install'],
      Package['augeas-tools']],
    notify  => Class['apache2::service'],
  } ->
  file_line { 'mpm_max_request_workers' :
    path    => "${apache2::params::mpm_config_file}",
    match   => "MaxRequestWorkers.*[0-9]+",
    after   => "<IfModule ${apache2::params::mpm_module}>",
    line    => "  MaxRequestWorkers        ${apache2::max_clients}",
    require => [
      Class['apache2::install'],
      Package['augeas-tools']],
    notify  => Class['apache2::service'],
  } ->
  file_line { 'mpm_max_connection_per_child' :
    path    => "${apache2::params::mpm_config_file}",
    match   => "MaxConnectionsPerChild.*[0-9]+",
    after   => "<IfModule ${apache2::params::mpm_module}>",
    line    => "  MaxConnectionsPerChild   ${apache2::max_requests_per_child}",
    require => [
      Class['apache2::install'],
      Package['augeas-tools']],
    notify  => Class['apache2::service'],
  } ->
  file_line { 'mpm_graceful_shutdown_timeout' :
    path    => "${apache2::params::mpm_config_file}",
    match   => "GracefulShutdownTimeout.*[0-9]+",
    after   => "<IfModule ${apache2::params::mpm_module}>",
    line    => "  GracefulShutDownTimeout  ${apache2::graceful_shutdown_timeout}",
    require => [
      Class['apache2::install'],
      Package['augeas-tools']],
    notify  => Class['apache2::service'],
  } ->
  file_line { 'mpm_graceful_server_limit' :
    path    => "${apache2::params::mpm_config_file}",
    match   => "ServerLimit.*[0-9]+",
    after   => "<IfModule ${apache2::params::mpm_module}>",
    line    => "  ServerLimit              ${apache2::server_limit}",
    require => [
      Class['apache2::install'],
      Package['augeas-tools']],
    notify  => Class['apache2::service'],
  }

}
