class apache2::mod::status ( $activated=true, $allow_from_all=false ) {
    apache2::module { "status":
        activated           => $activated,
        conf_file           => true,
        conf_file_template  => true,
        require             => [ Package [ "httpd" ], Class ["apache2::mod::proxy"] ],
    }

}