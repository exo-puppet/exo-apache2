class apache2::mod::proxy_ajp ( $activated=true ) {
    apache2::module { "proxy_ajp":
        activated   => $activated,
        conf_file   => false,
        require     => Package [ "httpd" ],
    }
}