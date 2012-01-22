class apache2::install {
	
	package { "httpd" : 
		name	=> $apache2::params::service_name,
		ensure 	=> $apache2::params::ensure_mode, 
	} -> 
	apache2::module { "rewrite":
	    activated  => true,
	    conf_file  => false,
	}
}