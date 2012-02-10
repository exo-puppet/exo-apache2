class apache2::install {
	
	package { "httpd" : 
		name	=> $apache2::params::service_name,
		ensure 	=> $apache2::params::ensure_mode, 
	} -> 
    # mod_rewrite
	apache2::module { "rewrite":
	    activated  => true,
	    conf_file  => false,
	} ->
	# mod_ssl
    apache2::module { "ssl":
        activated  => $apache2::ssl,
        conf_file  => true,
    } 
}