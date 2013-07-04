class apache2::install {
  package { 'httpd':
    ensure => $apache2::params::ensure_mode,
    name   => $apache2::params::service_name,
  } -> file { $apache2::params::certs_dir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0644,
  } -> class { 'apache2::mod::rewrite': activated => true } -> class { 'apache2::mod::ssl': activated => $apache2::ssl }
}
