class apache2::mod::rewrite ( $activated=true ) {
    apache2::module { "rewrite":
        activated   => $activated,
        conf_file   => false,
        require     => Package [ "httpd" ],
    }
}