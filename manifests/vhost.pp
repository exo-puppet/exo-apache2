# Class: apache2::vhost
#
#   This module manages apache2 virtual hosts.
#
#   Tested platforms:
#    - Ubuntu 11.04 Natty
#    - Ubuntu 10.10 maverick
#    - Ubuntu 10.04 Lucid
#
# Parameters:
# [+name+]
#   (OPTIONAL) (default: $title) 
#   
#   the name of the virtual host (ex: jira.exoplatform.org)
#
# [+activated+]
#   (OPTIONAL) (default: true) 
#   
#   this virtual host should be activated (true) or not (false)
#
# [+ssl+]
#   (OPTIONAL) (default: true) 
#   
#   this virtual host should be exposed with ssl (true) or not (false)
#
# [+server_aliases+]
#   (OPTIONAL) (default: <empty>) 
#   
#   1 (string) or more (Array of String) host aliases 
#
# [+admin_email+]
#   (OPTIONAL) (default: false) 
#   
#   the email of the administrator of the Virtual Host or false if we don't want this parameter. 
#
# [+document_root+]
#   (OPTIONAL) (default: /var/www) 
#   
#   The document root of the virtual host. 
#
# Sample Usage:
#
#   apache2::vhost { "jira.exoplatform.org":
#     activated         => true,
#     ssl               => true,
#     server_aliases    => [ "jira.*.exoplatform.org", "jira.exoplatform.com" ],
#     document_root     => "/var/www",
#   }
#
define apache2::vhost ( $activated=true, $ssl=true, $redirect2ssl = true,
                        $server_aliases=[], $admin_email=false,
                        $document_root="/var/www/" ) {
                            
#    if ( $ssl and $redirect2ssl ) {
#        $vhost_http_template = "apache2/apache2-vhost-redirect.erb"
#    } else {
#        $vhost_http_template = "apache2/apache2-vhost.erb"
#    }
    
    ########################
    # HTTP Configuration
    ########################
    # Create the VHost configuration file
    file { "${apache2::params::sites_available_dir}/${name}":
        ensure => file,
        owner  => root,
        group  => root,
        mode   => 0644,
        # path    => "${apache2::params::sites_available_dir}/${name}",
#        content =>  $ssl and $redirect2ssl ? {
        content =>  $ssl  ? {
            true    => $redirect2ssl ? {
                true    => template("apache2/apache2-vhost-redirect.erb"),
                default => template("apache2/apache2-vhost.erb"),
            },
            default => template("apache2/apache2-vhost.erb"),
        },
        require => Class[ "apache2::install" ],
        notify  => Class[ "apache2::service" ],
    } ->     
    # Activate or not the VHost configuration file
    file { "${apache2::params::sites_enabled_dir}/${name}":
        ensure => $activated ? {
            true    => "link",
            default => "absent"
        },
#        path    => $name == "default" ? {
#            true    => "000000-default",
#            default => $name,
#        },
        owner   => root,
        group   => root,
        mode    => 0644,
        target  => "${apache2::params::sites_available_dir}/${name}",
        require => File[ "${apache2::params::sites_available_dir}/${name}" ],
        notify  => Class[ "apache2::service" ],
    } ->
#    if ( $ssl == true ) {
    ########################
    # HTTPS Configuration (ssl)
    ########################
    # Create the VHost configuration file for SSL
    file { "${apache2::params::sites_available_dir}/${name}-ssl":
        ensure => $ssl ? {
            true    => file,
            default => "absent"
        },
        owner  => root,
        group  => root,
        mode   => 0644,
        # path    => "${apache2::params::sites_available_dir}/${name}",
        content => template ("apache2/apache2-vhost-ssl.erb"),
        require => Class[ "apache2::install" ],
        notify  => Class[ "apache2::service" ],
    } ->     
    # Activate or not the VHost configuration file
    file { "${apache2::params::sites_enabled_dir}/${name}-ssl":
#        ensure => $ssl and $activated ? {
        ensure => $ssl  ? {
            true    => $activated ? {
                true    => "link",
                default => "absent",
                },
            default => "absent",
        },
#        path    => $name == "default" ? {
#            true    => "000000-default-ssl",
#            default => $name,
#        },
        owner   => root,
        group   => root,
        mode    => 0644,
        target  => "${apache2::params::sites_available_dir}/${name}",
        require => File[ "${apache2::params::sites_available_dir}/${name}" ],
        notify  => Class[ "apache2::service" ],
    }

#    } else {
#        # Create the VHost configuration file
#        file { "${apache2::params::sites_available_dir}/${name}":
#            ensure => file,
#            owner  => root,
#            group  => root,
#            mode   => 0644,
#            # path    => "${apache2::params::sites_available_dir}/${name}",
#            content => template ("apache2/apache2-vhost.erb"),
#            require => Class[ "apache2::install" ],
#            notify  => Class[ "apache2::service" ],
#        } ->     
#        # Activate or not the VHost configuration file
#        file { "${apache2::params::sites_enabled_dir}/${name}":
#            ensure => $activated ? {
#                true    => "link",
#                default => "absent"
#            },
#            owner   => root,
#            group   => root,
#            mode    => 0644,
#            target  => "${apache2::params::sites_available_dir}/${name}",
#            require => File[ "${apache2::params::sites_available_dir}/${name}" ],
#            notify  => Class[ "apache2::service" ],
#        }
#    }
}