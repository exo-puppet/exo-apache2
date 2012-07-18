class apache2::mod::expires ( $activated=true ) {
    apache2::module { "expires":
        activated   => $activated,
        conf_file   => false,
        require     => Package [ "httpd" ],
    }
}