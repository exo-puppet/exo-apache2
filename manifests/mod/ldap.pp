# Module: apache2::mod::ldap
#
#   This module manages the apache2 mpm worker service.
# (apache2 MPM Worker documentation : http://httpd.apache.org/docs/2.2/mod/worker.html)
#
#   Tested platforms:
#    - Ubuntu 14.04 (Apache 2.4)
#    - Ubuntu 12.04 (Apache 2.2)
#
# Parameters:
#
#   $cache_entries :
#       Specifies the maximum size of the primary LDAP cache. This cache contains successful search/binds. Set it to 0 to turn off
#       search/bind caching. The default size is 1024 cached searches.
#
#   $cache_ttl :
#       Specifies the time (in seconds) that an item in the search/bind cache remains valid. The default is 600 seconds (10
#       minutes).
#
#   $connection_timeout :
#       Specifies the socket connection timeout in seconds. The default is 10 seconds, if the LDAP client library linked with the
#       server supports the LDAP_OPT_NETWORK_TIMEOUT option.
#
#   $connection_pool_ttl :
#       Specifies the maximum age, in seconds, that a pooled LDAP connection can remain idle and still be available for use.
#       Connections are cleaned up when they are next needed, not asynchronously.
#       A setting of 0 causes connections to never be saved in the backend connection pool. The default value of -1, and any other
#       negative value, allows connections of any age to be reused.
#       For performance reasons, the reference time used by this directive is based on when the LDAP connection is returned to the
#       pool, not the time of the last successful I/O with the LDAP server.
#       Since 2.4.10, new measures are in place to avoid the reference time from being inflated by cache hits or slow requests.
#       First, the reference time is not updated if no backend LDAP conncetions were needed. Second, the reference time uses the
#       time the HTTP request was received instead of the time the request is completed.
#       (This timeout defaults to units of seconds, but accepts suffixes for milliseconds (ms), minutes (min), and hours (h).)
#
#   $debug_level :
#       Turns on SDK-specific LDAP debug options that generally cause the LDAP SDK to log verbose trace information to the main
#       Apache error log.
#       The trace messages from the LDAP SDK provide gory details that can be useful during debugging of connectivity problems with
#       backend LDAP servers.
#       This option is only configurable when Apache HTTP Server is linked with an LDAP SDK that implements LDAP_OPT_DEBUG or
#       LDAP_OPT_DEBUG_LEVEL,
#       such as OpenLDAP (a value of 7 is verbose) or Tivoli Directory Server (a value of 65535 is verbose).
#
#   $op_cache_entries :
#       This specifies the number of entries mod_ldap will use to cache LDAP compare operations. The default is 1024 entries.
#       Setting it to 0 disables operation caching.
#
#   $op_cache_ttl :
#       Specifies the time (in seconds) that entries in the operation cache remain valid. The default is 600 seconds.
#
#   $retries :
#       The server will retry failed LDAP requests up to LDAPRetries times. Setting this directive to 0 disables retries.
#       LDAP errors such as timeouts and refused connections are retryable.
#
#   $retry_delay :
#       If LDAPRetryDelay is set to a non-zero value, the server will delay retrying an LDAP request for the specified amount of
#       time. Setting this directive to 0 will result in any retry to occur without delay.
#       LDAP errors such as timeouts and refused connections are retryable.
#
#   $shared_cache_size :
#       Specifies the number of bytes to allocate for the shared memory cache. The default is 500kb. If set to 0, shared memory
#       caching will not be used and every HTTPD process will create its own cache.
#
#   $timeout :
#       This directive configures the timeout for bind and search operations, as well as the LDAP_OPT_TIMEOUT option in the
#       underlying LDAP client library, when available.
#       If the timeout expires, httpd will retry in case an existing connection has been silently dropped by a firewall. However,
#       performance will be much better if the firewall is configured to send TCP RST packets instead of silently dropping packets.
#       (Timeouts for ldap compare operations requires an SDK with LDAP_OPT_TIMEOUT, such as OpenLDAP >= 2.4.4.)
#
class apache2::mod::ldap (
  $activated           = true,
  $cache_entries       = '1024',
  $cache_ttl           = '600',
  $connection_timeout  = '10',
  $connection_pool_ttl = '-1',
  $debug_level         = 'disabled',
  $op_cache_entries    = '1024',
  $op_cache_ttl        = '600',
  $retries             = '3',
  $retry_delay         = '0',
  $shared_cache_size   = '500000',
  $timeout             = '60') {
  apache2::module { 'ldap':
    activated          => $activated,
    conf_file          => true,
    conf_file_template => true,
    require            => Package['httpd'],
  }

  apache2::module { 'authnz_ldap':
    activated => $activated,
    conf_file => false,
    require   => [
      Package['httpd'],
      Apache2::Module['ldap']],
  }
}
