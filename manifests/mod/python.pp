class apache2::mod::python (
  $activated = true) {
  apache2::module { 'python':
    activated    => $activated,
    package_name => 'libapache2-mod-python',
    conf_file    => false,
    require      => Package['httpd'],
  }
}
