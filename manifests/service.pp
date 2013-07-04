class apache2::service {
  service { $apache2::params::service_name:
    ensure     => running,
    # enable has no effect for Ubuntu
    # look at : http://docs.puppetlabs.com/references/2.7.6/type.html#service (ubuntu provider = upstart)
    enable     => true,
    name       => $apache2::params::service_name,
    hasstatus  => true,
    hasrestart => false,
    require    => Class['apache2::config'],
  }
}
