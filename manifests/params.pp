class apache2::params {
	
	$ensure_mode = $apache2::lastversion ? {
		true => latest,
		default => present
	}
	info ("${module_name} ensure mode = $ensure_mode")
	
	case $::operatingsystem {
		/(Ubuntu|Debian)/: {
			$service_name			= 'apache2'
			$package_name			= 'apache2-mpm-worker'
			$user					= 'www-data'
			$group					= 'www-data'
			#$ssl_package			= 'apache-ssl'
			$config_file			= '/etc/apache2/apache2.conf'
			$sites_available_dir	= '/etc/apache2/sites-available'
			$sites_enabled_dir		= '/etc/apache2/sites-enabled'
			$mods_available_dir		= '/etc/apache2/mods-available'
			$mods_enabled_dir		= '/etc/apache2/mods-enabled'
		}
		default: {
			fail ("The ${module_name} module is not supported on $::operatingsystem")
		}
	}
}