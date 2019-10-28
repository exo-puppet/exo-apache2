class apache2::mod::disk_cache (
  $activated = true) {

  case $apache2::params::apache_version {
    /(2.2)/ : {
      apache2::module { 'disk_cache':
        activated          => $activated,
        conf_file          => true,
        conf_file_template => true,
        require            => [
          Package['httpd'],
          Class['apache2::mod::cache']],
      }
    }
    default : {
      fail("The ${module_name} module is not supported un Apache [${apache2::params::apache_version}] version, please use cache_disk module instead")
    }
  }
}
