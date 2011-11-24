# Class: apache2
#
#   This module manages the apache2 service.
#
#   Tested platforms:
#    - Ubuntu 11.04 Natty
#
# Parameters:
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
#     lastversion => false,
#   }
#
# [Remember: No empty lines between comments and class definition]
class apache2 ($lastversion=false) {
	# parameters validation
	if ($lastversion != true) and ($lastversion != false) {
		fail("lastversion must be true or false")
	}

	# submodules 
	include apache2::params, apache2::install, apache2::config, apache2::service
}
