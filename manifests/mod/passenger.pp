class apache2::mod::passenger ( $activated=true ) {
    apache2::module { "passenger":
        activated           => $activated,
        package_name        => "libapache2-mod-passenger",
        conf_file           => true,
        conf_file_template  => true,
        require             => [ Package [ "httpd" ] ],
    }
}
