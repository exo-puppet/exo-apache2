class apache2::mod::proxy (
  $activated = true) {
  apache2::module { 'proxy':
    activated => $activated,
    conf_file => true,
    require   => Package['httpd'],
  }
}
