# Class: apache2
#
#   This module manages the apache2 mpm worker service.
#	(apache2 MPM Worker documentation : http://httpd.apache.org/docs/2.2/mod/worker.html)
#
#   Tested platforms:
#    - Ubuntu 11.04 Natty
#
# Parameters:
#	$start_servers:
#		initial number of server processes to start (default: 2)
#	$min_spare_threads:
#		minimum number of worker threads which are kept spare (default: 25)
#	$max_spare_threads:
#		maximum number of worker threads which are kept spare (default: 75)
#	$thread_limit:
#		is a hard limit of the number of server threads, and must be greater than or equal to the ThreadsPerChild directive (default: 64)
#	$thread_per_child:
#		constant number of worker threads in each server process (default: 25)
#	$max_clients:
#		maximum number of simultaneous client connections (default: 150)
#	$max_requests_per_child:
#		maximum number of requests a server process serves (default: 0)
#	$timeout:
#		Amount of time (in seconds) the server will wait for certain events before failing a request (default: 300) (doc : http://httpd.apache.org/docs/2.2/mod/core.html#timeout)
#	$keepalive:
#		Enables HTTP persistent connections (On) or not (Off) (default: On) (doc : http://httpd.apache.org/docs/2.2/mod/core.html#keepalive)
#	$max_keepalive_requests:
#		limits the number of requests allowed per connection when KeepAlive is on. If it is set to 0, unlimited requests will be allowed. We recommend that this setting be kept to a high value for maximum server performance. (default: 500) 
#		(doc : http://httpd.apache.org/docs/2.2/mod/core.html#maxkeepaliverequests)
#   $keepalive_timeout:
#       Amount of time (in seconds) the server will wait for subsequent requests on a persistent connection (default: 15) (doc : http://httpd.apache.org/docs/2.2/mod/core.html#keepalivetimeout)
#   $ssl:
#       activate (true) or not (false) mod_ssl
#	$lastversion:
#		this variable allow to chose if the package should always be updated to the last available version (true) or not (false) (default: false)
#
# Actions:
#
#  Installs, configures, and manages the apache 2 service.
#
# Requires:
#
# Sample Usage:
#
#   class { "apache2":
#		start_servers			=> "2",
#		min_spare_threads		=> "25",
#		max_spare_threads		=> "75",
#		thread_limit			=> "64",
#		thread_per_child		=> "25",
#		max_clients				=> "150",
#		max_requests_per_child	=> "0",
#		timeout					=> "300",
#		keepalive				=> "On",
#		max_keepalive_requests	=> "500",
#		keepalive_timeout		=> "15",
#		lastversion 			=> false,
#   }
#
# [Remember: No empty lines between comments and class definition]
class apache2 ( $start_servers = "2", 
				$min_spare_threads = "25", 
				$max_spare_threads = "75",  
				$thread_limit = "64",  
				$thread_per_child = "25",  
				$max_clients = "150",  
				$max_requests_per_child = "0", 
				$timeout = "300",
				$keepalive = "On",
				$max_keepalive_requests = "500",
				$keepalive_timeout = "15",
				$ssl = false,
				$lastversion = false) {
	# parameters validation
	if ($lastversion != true) and ($lastversion != false) {
		fail("lastversion must be true or false")
	}
	if ($keepalive != "On") and ($keepalive != "Off") {
		fail("keepalive must be On or Off")
	}

	# submodules 
	include apache2::params, apache2::install, apache2::config, apache2::service
}
