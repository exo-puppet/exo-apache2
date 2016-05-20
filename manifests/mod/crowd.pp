# Module apache2::mod::crowd
#
# Compatibility :
#   - Apache 2.2
#
# This module manage Atlassian Crowd apache 2 module installation.
# If we are in an Apache 2.2 context, the module is installed regarding the $activated parameter value.
# If we are in another Apache version context, nothing is installed and the Apache module + Ubuntu package are authomatically
# uninstalled if present.
#
class apache2::mod::crowd (
  $activated = true,
  $package_download_directory) {
  case $apache2::params::apache_version {
    /(2.2)/ : {
      # Install the required packages
      ensure_packages ( 'libapache2-svn' , { 'require' => Class['apt::update'] } )

      ensure_packages ( 'libcurl3' , { 'require' => Class['apt::update'] } )
      # Download the deb package
      $module_deb_filename = 'libapache2-mod-authnz-crowd_2.0.2-1_amd64.deb'
      wget::fetch { 'download-libapache2-mod-authnz-crowd':
        source_url        => "https://github.com/bpaquet/libapache2-mod-authnz-crowd/raw/master/${module_deb_filename}",
        target_directory  => $package_download_directory,
        target_file       => $module_deb_filename,
        timeout           => 0,
        check_certificate => false,
        require           => File[$package_download_directory]
      }
      # Install the downloaded package
      ensure_packages ( 'libapache2-mod-authnz-crowd', {
        'provider' => dpkg,
        'source'   => "${package_download_directory}/${module_deb_filename}",
        'require'  => [
          Wget::Fetch['download-libapache2-mod-authnz-crowd'],
          Package['libapache2-svn']],
      } )
      # Add the Apache 2 module
      apache2::module { 'authnz_crowd':
        activated => $activated,
        conf_file => false,
        require   => Package[
          'httpd', 'libapache2-mod-authnz-crowd'],
      }
    }
    default : {
      # We enforce the module is removed
      apache2::module { 'authnz_crowd': activated => false } ->
      # Install the downloaded package
      package { 'libapache2-mod-authnz-crowd': ensure => 'purged' }
      warning("The ${module_name} module don't support Apache [${apache2::params::apache_version}] version, nothing will be installed."
      )
    }
  }

}
