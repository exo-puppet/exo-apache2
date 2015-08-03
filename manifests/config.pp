class apache2::config {
  ####################################
  # Apache main config file check
  ####################################
  file { $apache2::params::config_file:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Class['apache2::install'],
    notify  => Class['apache2::service'],
  } ->
  ####################################
  # Configure global Apache settings
  ####################################
  augeas { 'configure-apache2-global-settings':
    context => "/files${apache2::params::config_file}",
    changes => [
      "set *[self::directive='Timeout']/arg \"${apache2::timeout}\"",
      "set *[self::directive='KeepAlive']/arg \"${apache2::keepalive}\"",
      "set *[self::directive='MaxKeepAliveRequests']/arg \"${apache2::max_keepalive_requests}\"",
      "set *[self::directive='KeepAliveTimeout']/arg \"${apache2::keepalive_timeout}\"",
      ],
    require => [
      Class['apache2::install'],
      Package['augeas-tools']],
    notify  => Class['apache2::service'],
  } ->
  ####################################
  # Configure the MPM Worker module
  ####################################
  augeas { 'configure-apache2-mpm-worker-module':
    context => "/files${apache2::params::config_file}",
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
  } ->
  ####################################
  # Add SSL Certificats if specified
  ####################################
  apache2::certificate { 'ssl' :
    ssl_cert_file => $apache2::ssl_cert_file,
    ssl_cert_key_file => $apache2::ssl_cert_key_file,
    ssl_cert_chain_file => $apache2::ssl_cert_chain_file,
  } ->
  ####################################
  # Configure NamedVirtualHost if any
  ####################################
  apache2::conf { 'virtual':
    conf_file_template  => true,
    activated => $apache2::params::apache_version ? {
      '2.2' => $apache2::name_virtual_host_ports ? {
          false   => false,
          default => true,
        },
      '2.4'   => false,
      default => fail("The ${module_name} module don't support Apache [${apache2::params::apache_version}] version")
    }

  } ->
  ####################################
  # Add default Virtual Host
  ####################################
  file { $apache2::default_document_root:
    ensure => directory,
    owner  => $apache2::params::user,
    group  => $apache2::params::group,
  } -> apache2::vhost { 'default':
    activated     => true,
    ssl           => $apache2::ssl,
    ssl_cert_name => $apache2::default_cert_name,
    redirect2ssl  => false,
    order         => '000',
    document_root => $apache2::default_document_root,
    includes      => $apache2::default_vhost_includes,
  }
}
