class apache2::mod::ssl (
  $activated = true) {
  case $apache2::params::apache_version {
    /(2.2)/ : {
      apache2::module { 'ssl':
        activated => $activated,
        conf_file => true,
        require   => Package['httpd'],
      }
    }
    /(2.4)/ : {
      apache2::module { 'socache_shmcb':
        activated => $activated,
        conf_file => false,
        require   => Package['httpd'],
      }

      apache2::module { 'ssl':
        activated => $activated,
        conf_file => true,
        require   => [
          Package['httpd'],
          Apache2::Module['socache_shmcb']],
      }
    }
    default : {
      fail("The ${module_name} module don't support Apache [${apache2::params::apache_version}] version")
    }
  }
}
