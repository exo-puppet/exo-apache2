class apache2::mod::cache (
  $activated = true) {
  apache2::module { 'cache':
    activated => $activated,
    conf_file => false,
    require   => Package['httpd'],
  }
}
