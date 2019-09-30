class apache2::mod::cache_disk (
  $activated = true) {
    apache2::module { 'cache_disk':
      activated          => $activated,
      conf_file          => true,
      conf_file_template => true,
      require            => [
        Package['httpd'],
        Class['apache2::mod::cache']],
    }
}
