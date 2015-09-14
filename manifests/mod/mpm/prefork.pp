class apache2::mod::mpm::prefork {
  # Define here prefork specific parameters
  # MaxSpareServer
  # MinSpareServer
  file_line { 'mpm_server_limit' :
    path    => "${apache2::params::mpm_config_file}",
    match   => "ServerLimit.*[0-9]+",
    after   => "<IfModule ${apache2::params::mpm_module}>",
    line    => "  ServerLimit              ${apache2::max_clients}",
    require => [
      Class['apache2::install'],
      Package['augeas-tools']],
    notify  => Class['apache2::service'],
  }
}
