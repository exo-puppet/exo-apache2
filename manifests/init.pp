# Class: apache2
#
#   This module manages the apache2 mpm worker service.
# (apache2 MPM Worker documentation : http://httpd.apache.org/docs/2.2/mod/worker.html)
#
#   Tested platforms:
#    - Ubuntu 14.04 (Apache 2.4)
#    - Ubuntu 12.04 (Apache 2.2)
#    - Ubuntu 11.04 (Apache 2.2)
#
# Parameters:
# $start_servers:
# 	initial number of server processes to start (default: 2)
# $min_spare_threads:
# 	minimum number of worker threads which are kept spare (default: 25)
# $max_spare_threads:
# 	maximum number of worker threads which are kept spare (default: 75)
# $thread_limit:
# 	is a hard limit of the number of server threads, and must be greater than or equal to the ThreadsPerChild directive (default: 64)
# $thread_per_child:
# 	constant number of worker threads in each server process (default: 25)
# $max_clients:
# 	maximum number of simultaneous client connections (default: 150)
# $max_requests_per_child:
# 	maximum number of requests a server process serves (default: 0)
# $timeout:
# 	Amount of time (in seconds) the server will wait for certain events before failing a request (default: 300) (doc :
#  http://httpd.apache.org/docs/2.2/mod/core.html#timeout)
# $keepalive:
# 	Enables HTTP persistent connections (On) or not (Off) (default: On) (doc :
#  http://httpd.apache.org/docs/2.2/mod/core.html#keepalive)
# $max_keepalive_requests:
# 	limits the number of requests allowed per connection when KeepAlive is on. If it is set to 0, unlimited requests will be allowed.
#  We recommend that this setting be kept to a high value for maximum server performance. (default: 500)
# 	(doc : http://httpd.apache.org/docs/2.2/mod/core.html#maxkeepaliverequests)
#   $keepalive_timeout:
#       Amount of time (in seconds) the server will wait for subsequent requests on a persistent connection (default: 15) (doc :
#       http://httpd.apache.org/docs/2.2/mod/core.html#keepalivetimeout)
#   $ssl:
#       activate (true) or not (false) mod_ssl
#   $default_cert_name :
#       Certificate name to use on default vhost
#   $ssl_cert_file:
#       A certificat file
#   $ssl_cert_key_file:
#       A certificat key file
#   $ssl_cert_chain_file:
#       A certificat chain file
#   $includes_dir:
#       the directory where configuration file to include will be stored
#   $ssl_jdk16_compatible
#       Deploy a less secure ssl configuration for vhosts accessed by jdk1.6 clients
# $lastversion:
# 	this variable allow to chose if the package should always be updated to the last available version (true) or not (false)
#  (default: false)
#
# Actions:
#
#  Installs, configures, and manages the apache 2 service.
#
# Requires:
#
# Sample Usage:
#
#   class { 'apache2':
#       start_servers			=> '2',
#       min_spare_threads		=> '25',
#       max_spare_threads		=> '75',
#       thread_limit			=> '64',
#       thread_per_child		=> '25',
#       max_clients				=> '150',
#       max_requests_per_child	=> '0',
#       timeout					=> '300',
#       keepalive				=> 'On',
#       max_keepalive_requests	=> '500',
#       keepalive_timeout       => '15',
#       ssl                     => true,
#       ssl_cert_file          = 'puppet:///modules/perso/fichier-cert.cer',
#       ssl_cert_key_file      = 'puppet:///modules/perso/fichier-cert.key',
#       ssl_cert_chain_file    = 'puppet:///modules/perso/fichier-cert-chain.txt',
#       includes_dir            => '/etc/apache2/includes',
#       # Named Virtual Hosts on port 80 and 443 for all IP
#       name_virtual_host_ports => [ '*:80', '*:443' ],
#       lastversion 			=> false,
#   }
#
# [Remember: No empty lines between comments and class definition]
class apache2 (
  $start_servers              = '2',
  $min_spare_threads          = '25',
  $max_spare_threads          = '75',
  $thread_limit               = '64',
  $thread_per_child           = '25',
  $max_clients                = '150',
  $max_requests_per_child     = '0',
  $graceful_shutdown_timeout  = '60', # For apache >= 2.4
  $server_limit               = '16', # Apache default value (MaxSpareThreads / ThreadPerChilds)
  $timeout                    = '300',
  $keepalive                  = 'On',
  $max_keepalive_requests     = '500',
  $keepalive_timeout          = '15',
  $ssl                        = false,
  $default_cert_name          = "ssl",
  $ssl_cert_file              = "false",
  $ssl_cert_key_file          = "false",
  $ssl_cert_chain_file        = "false",
  $ssl_jdk16_compatible       = false,
  $error_403_uri              = false,
  $error_404_uri              = false,
  $error_500_uri              = false,
  $error_502_uri              = false,
  $error_503_uri              = false,
  $includes_dir               = false,
  $name_virtual_host_ports    = false,
  $default_admin_email        = "webmaster@${::fqdn}",
  $default_document_root      = '/var/www/',
  $default_vhost_includes     = [],
  $lastversion                = false) {
  # parameters validation
  if ($lastversion != true) and ($lastversion != false) {
    fail('lastversion must be true or false')
  }

  if ($keepalive != 'On') and ($keepalive != 'Off') {
    fail('keepalive must be On or Off')
  }

  # modules dependencies
  include repo

  # internal classes
  include apache2::params, apache2::install, apache2::config, apache2::service
}
