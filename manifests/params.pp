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
			
            $config_dir             = "/etc/apache2"
            $config_file            = "${config_dir}/apache2.conf"
			
            $certs_dir              = "${config_dir}/certs"
            $ssl_cert_file          = "${certs_dir}/ssl-cert.cer"
            $ssl_cert_key_file      = "${certs_dir}/ssl-cert.key"
            $ssl_cert_chain_file    = "${certs_dir}/ssl-chain.txt"
            
            $includes_dir           = $apache2::includes_dir ? {
                    false   => "${config_dir}/includes",
                    default => $apache2::includes_dir,
                }
            $confd_dir              = "${config_dir}/conf.d"
            
            $sites_available_dir    = "${config_dir}/sites-available"
            $sites_enabled_dir      = "${config_dir}/sites-enabled"

			$mods_available_dir		= "${config_dir}/mods-available"
			$mods_enabled_dir		= "${config_dir}/mods-enabled"
		}
		default: {
			fail ("The ${module_name} module is not supported on $::operatingsystem")
		}
	}
}