class apache2::mod::passenger ( $activated=true ) {
    apache2::module { "passenger":
        activated           => $activated,
        conf_file           => true,
        conf_file_template  => true,
        require             => [ Package [ "httpd" ] ],
    }
}
