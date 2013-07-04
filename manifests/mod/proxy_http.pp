class apache2::mod::proxy_http (
  $activated = true) {
  apache2::module { 'proxy_http':
    activated => $activated,
    conf_file => false,
    require   => [
      Package['httpd'],
      Class['apache2::mod::proxy']]
  }
}
