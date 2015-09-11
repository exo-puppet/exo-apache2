class apache2::mod::proxy_wstunnel (
  $activated = true) {
  case $apache2::params::apache_version {
    /(2.2)/ : {
      fail("The ${module_name} module don't support Apache [${apache2::params::apache_version}] version")
    }
    default : {
      apache2::module { 'proxy_wstunnel':
        activated => $activated,
        conf_file => false,
        require   => [
          Package['httpd'],
          Class['apache2::mod::proxy']]
      }
    }
  }
}
