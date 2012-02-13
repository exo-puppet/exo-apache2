class apache2::mod::php5 ( $activated=true ) {
    apache2::module { "php5":
        activated       => $activated,
        package_name    => "libapache2-mod-php5",
        conf_file       => true,
        require         => Package [ "httpd" ],
    }
}