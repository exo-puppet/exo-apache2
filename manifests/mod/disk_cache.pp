class apache2::mod::disk_cache (
  $activated = true) {
  apache2::module { 'disk_cache':
    activated          => $activated,
    conf_file          => true,
    conf_file_template => true,
    require            => [
      Package['httpd'],
      Class['apache2::mod::cache']],
  }
}
