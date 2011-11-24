class apache2::config {
	file { $apache2::params::config_file:
		ensure => file,
		owner  => root,
		group  => root,
		mode   => 0644,
		#content => template("ntp/$ntp::params::config_template"),
		require => Class["apache2::install"],
		notify => Class["apache2::service"],
	}
}