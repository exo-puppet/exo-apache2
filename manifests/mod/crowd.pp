class apache2::mod::crowd ( $activated=true, $package_download_directory ) {

    # Download the deb package
    wget::fetch { "download-libapache2-mod-authnz-crowd_2.0.2-1_amd64.deb":
        source_url          => "https://github.com/bpaquet/libapache2-mod-authnz-crowd/raw/master/libapache2-mod-authnz-crowd_2.0.2-1_amd64.deb",
        target_directory    => "${package_download_directory}",
        target_file         => "libapache2-mod-authnz-crowd_2.0.2-1_amd64.deb",
        timeout             => 0,
        check_certificate   => false,
        require             => File [ "${package_download_directory}" ]
    } ->
    # Install the required packages
    package { "libapache2-svn": } ->
    package { "libcurl3": } ->
    # Install the downloaded package
    package { "libapache2-mod-authnz-crowd" :
        provider    => dpkg,
        source      => "${package_download_directory}/libapache2-mod-authnz-crowd_2.0.2-1_amd64.deb",
        require     => [ Wget::Fetch["download-libapache2-mod-authnz-crowd_2.0.2-1_amd64.deb"] ],
    } ->
    # Add the Apache 2 module
    apache2::module { "authnz_crowd":
        activated  => $activated,
        conf_file  => false,
        require     => Package [ "httpd", "libapache2-mod-authnz-crowd" ],
    }
}
