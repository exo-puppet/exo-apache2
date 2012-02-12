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
# [+redirect2ssl+]
#   (OPTIONAL) (default: true) 
#   
#   If ssl is activated, we can automaticaly redirect the non-ssl vhost to its ssl version (true) or not (false)
#
# [+order+]
#   (OPTIONAL) (default: 100) 
#   
#   Use a string numerical value to order the VHosts (000 is use by the default vhost) 
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
#     server_aliases    => [ "jira.*.exoplatform.org", "jira-*.exoplatform.org" ],
#     admin_email       => "admin@test.com",
#     document_root     => "/var/www",
#   }
#
define apache2::vhost ( $activated=true, $ssl=true, $redirect2ssl = true, $order = "100",
                        $server_aliases=[], $admin_email=false,
                        $document_root="/var/www/",
                        $includes=[] ) {
                            
    ########################
    # HTTP Configuration
    ########################
    # Create the VHost configuration file
    file { "${apache2::params::sites_available_dir}/${name}":
        ensure => file,
        owner  => root,
        group  => root,
        mode   => 0644,
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
    file { "${apache2::params::sites_enabled_dir}/${order}-${name}":
        ensure => $activated ? {
            true    => "link",
            default => "absent"
        },
        owner   => root,
        group   => root,
        mode    => 0644,
        target  => "${apache2::params::sites_available_dir}/${name}",
        require => File[ "${apache2::params::sites_available_dir}/${name}" ],
        notify  => Class[ "apache2::service" ],
    } ->
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
    file { "${apache2::params::sites_enabled_dir}/${order}-${name}-ssl":
        ensure => $ssl  ? {
            true    => $activated ? {
                true    => "link",
                default => "absent",
                },
            default => "absent",
        },
        owner   => root,
        group   => root,
        mode    => 0644,
        target  => "${apache2::params::sites_available_dir}/${name}-ssl",
        require => File[ "${apache2::params::sites_available_dir}/${name}-ssl" ],
        notify  => Class[ "apache2::service" ],
    }
}