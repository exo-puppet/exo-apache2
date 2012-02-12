class apache2::mod::headers ( $activated=true ) {
    apache2::module { "headers":
        activated   => $activated,
        conf_file   => false,
        require     => Package [ "httpd" ],
    }
}