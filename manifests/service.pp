class apache2::service {
	service { $apache2::params::service_name:
		ensure     	=> running,
		name       	=> $apache2::params::service_name,
		hasstatus  	=> true,
		hasrestart 	=> true,
		require 	=> Class["apache2::config"],
	}
}