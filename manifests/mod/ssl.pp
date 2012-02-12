class apache2::mod::ssl ( $activated=true ) {
    apache2::module { "ssl":
        activated  => $activated,
        conf_file  => true,
        require     => Package [ "httpd" ],
    }
}