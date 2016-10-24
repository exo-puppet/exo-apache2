class apache2::mod::cgi (
  $activated = true) {
  apache2::module { 'cgi':
    activated => $activated,
    conf_file => false,
    require   => Package['httpd'],
  }
}
