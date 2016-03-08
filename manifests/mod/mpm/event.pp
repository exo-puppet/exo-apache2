class apache2::mod::mpm::event {
  file_line { 'mpm_thread_per_child' :
    path    => "${apache2::params::mpm_config_file}",
    match   => "ThreadsPerChild.*[0-9]+",
    after   => "<IfModule ${apache2::params::mpm_module}>",
    line    => "  ThreadsPerChild          ${apache2::thread_per_child}",
    require => [
      Class['apache2::install'],
      Package['augeas-tools']],
    notify  => Class['apache2::service'],
  } ->
  file_line { 'mpm_thread_limit' :
    path    => "${apache2::params::mpm_config_file}",
    match   => "ThreadLimit.*[0-9]+",
    after   => "<IfModule ${apache2::params::mpm_module}>",
    line    => "  ThreadLimit              ${apache2::thread_limit}",
    require => [
      Class['apache2::install'],
      Package['augeas-tools']],
    notify  => Class['apache2::service'],
  } ->
  file_line { 'mpm_min_spare_threads' :
    path    => "${apache2::params::mpm_config_file}",
    match   => "MinSpareThreads.*[0-9]+",
    after   => "<IfModule ${apache2::params::mpm_module}>",
    line    => "  MinSpareThreads          ${apache2::min_spare_threads}",
    require => [
      Class['apache2::install'],
      Package['augeas-tools']],
    notify  => Class['apache2::service'],
  } ->
  file_line { 'mpm_max_spare_threads' :
    path    => "${apache2::params::mpm_config_file}",
    match   => "MaxSpareThreads.*[0-9]+",
    after   => "<IfModule ${apache2::params::mpm_module}>",
    line    => "  MaxSpareThreads          ${apache2::max_spare_threads}",
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
