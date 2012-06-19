class apache2::mod::proxy_balancer ( $activated=true, $balancer_status=true, $balancer_status_show_all=false ) {
    apache2::module { "proxy_balancer":
        activated           => $activated,
        conf_file           => true,
        conf_file_template  => true,
        require             => [ Package [ "httpd" ], Class ["apache2::mod::status", "apache2::mod::proxy"] ]
    }
}