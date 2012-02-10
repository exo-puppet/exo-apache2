class apache2::config {
	
	# Apache main config file check
	file { $apache2::params::config_file:
		ensure => file,
		owner  => root,
		group  => root,
		mode   => 0644,
		require => Class["apache2::install"],
		notify => Class["apache2::service"],
	}

	# Configure global Apache settings
	augeas { "configure-apache2-global-settings":
		context	=> "/files${apache2::params::config_file}",
		changes	=> [
			"set *[self::directive='Timeout']/arg \"${apache2::timeout}\"",
			"set *[self::directive='KeepAlive']/arg \"${apache2::keepalive}\"",
			"set *[self::directive='MaxKeepAliveRequests']/arg \"${apache2::max_keepalive_requests}\"",
			"set *[self::directive='KeepAliveTimeout']/arg \"${apache2::keepalive_timeout}\"",
		],
		require => Class["apache2::install"],
		notify => Class["apache2::service"],
	}
	
	# Configure the MPM Worker module
	augeas { "configure-apache2-mpm-worker-module":
		context	=> "/files${apache2::params::config_file}",
		changes	=> [
			"set IfModule[arg = 'mpm_worker_module']/*[self::directive='StartServers']/arg \"${apache2::start_servers}\"",
			"set IfModule[arg = 'mpm_worker_module']/*[self::directive='MinSpareThreads']/arg \"${apache2::min_spare_threads}\"",
			"set IfModule[arg = 'mpm_worker_module']/*[self::directive='MaxSpareThreads']/arg \"${apache2::max_spare_threads}\"",
			"set IfModule[arg = 'mpm_worker_module']/*[self::directive='ThreadLimit']/arg \"${apache2::thread_limit}\"",
			"set IfModule[arg = 'mpm_worker_module']/*[self::directive='ThreadsPerChild']/arg \"${apache2::thread_per_child}\"",
			"set IfModule[arg = 'mpm_worker_module']/*[self::directive='MaxClients']/arg \"${apache2::max_clients}\"",
			"set IfModule[arg = 'mpm_worker_module']/*[self::directive='MaxRequestsPerChild']/arg \"${apache2::max_requests_per_child}\"",
		],
		require => Class["apache2::install"],
		notify => Class["apache2::service"],
	}

    apache2::vhost { "default":
        activated       => true,
        ssl             => true,
        redirect2ssl    => false,
#        server_aliases  => [ "ci.*.exoplatform.org" ],
        admin_email     => "exo-swf@exoplatform.com",
    }
}