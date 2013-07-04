class apache2::mod::proxy_balancer (
  $activated = true) {
  apache2::module { 'proxy_balancer':
    activated          => $activated,
    conf_file          => true,
    conf_file_template => false,
    require            => [
      Package['httpd'],
      Class['apache2::mod::status', 'apache2::mod::proxy']]
  }
}
