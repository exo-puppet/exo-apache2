class apache2::install {
  package { 'httpd':
    ensure  => $apache2::params::ensure_mode,
    name    => $apache2::params::service_name,
    require => [
      Exec['repo-update'],],
  } -> file { $apache2::params::certs_dir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0644',
  } -> class { 'apache2::mod::rewrite': activated => true } -> class { 'apache2::mod::ssl': activated => $apache2::ssl }

  # In old Apache distributions the APACHE_LOG_DIR envvar wasn't definied and me need it in our config files
  # We patch the envvars to add this declaration if we don't find it APACHE_LOG_DIR
  exec { 'add-APACHE_LOG_DIR-in-envvars':
    command => "/bin/echo -e \"\\n# for supporting multiple apache2 instances\\nif [ \\\"\\\${APACHE_CONFDIR##/etc/apache2-}\\\" != \\\"\\\${APACHE_CONFDIR}\\\" ] ; then\nSUFFIX=\\\"-\\\${APACHE_CONFDIR##/etc/apache2-}\\\"\nelse\nSUFFIX=\nfi\n# Only /var/log/apache2 is handled by /etc/logrotate.d/apache2\nexport APACHE_LOG_DIR=/var/log/apache2\\\$SUFFIX\n\" >> ${apache2::params::config_dir}/envvars",
    unless  => "cat ${apache2::params::config_dir}/envvars | grep \"APACHE_LOG_DIR\"",
    notify  => Service[$apache2::params::service_name],
    require => Package['httpd']
  }
}
