class apache2::mod::passenger (
  $activated = true) {
  apt::source { 'passenger':
    location => 'https://oss-binaries.phusionpassenger.com/apt/passenger',
    key      => '16378A33A6EF16762922526E561F9B9CAC40B2F7',
    repos    => 'main',
    release  => "${lsbdistcodename}",
    require  => Package['apt-transport-https','ca-certificates'],
  }

  apache2::module { 'passenger':
    activated          => $activated,
    package_name       => 'libapache2-mod-passenger',
    conf_file          => true,
    conf_file_template => true,
    require            => [Package['httpd'],Apt::Source['passenger']],
  }
}
