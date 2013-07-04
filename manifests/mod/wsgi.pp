class apache2::mod::wsgi (
  $activated = true) {
  apache2::module { 'wsgi':
    activated    => $activated,
    package_name => 'libapache2-mod-wsgi',
    conf_file    => true,
    require      => Package['httpd'],
  }
}
