################################################################################
#
#   This module manages the Apache 2 mod_mem_cache module.
#
#   Tested platforms:
#    - Ubuntu 11.10 Oneiric
#    - Ubuntu 11.04 Natty
#    - Ubuntu 10.04 Lucid
#
#
# == Parameters
#   [+activated+]
#       (OPTIONAL) (default: true)
#
#       this variable allows to activate or deactivate the module (values : true | false)
#
#   [+size+]
#       (OPTIONAL) (default: 4096 => 4 MB)
#
#       this variable allows to configuration the amount of memory in KBytes allocated for the cache
#
#   [+max_object_count+]
#       (OPTIONAL) (default: 1009)
#
#       this directive sets the maximum number of objects to be cached. The value is used to create the open hash table.
#       If a new object needs to be inserted in the cache and the maximum number of objects has been reached,
#       an object will be removed to allow the new object to be cached. The object to be removed is selected
#       using the algorithm specified by $removal_algorithm parameter.
#
#   [+min_object_size+]
#       (OPTIONAL) (default: 1)
#
#       this directive sets the minimum size in bytes of a document for it to be considered cacheable.
#
#   [+max_object_size+]
#       (OPTIONAL) (default: 10000)
#
#       this directive sets the maximum allowable size, in bytes, of a document for it to be considered cacheable.
#
#   [+removal_algorithm+]
#       (OPTIONAL) (default: GDSF)
#
#       this directive specifies the algorithm used to select documents for removal from the cache. Two choices are available:
#           - LRU (Least Recently Used) : LRU removes the documents that have not been accessed for the longest time.
#           - GDSF (GreadyDual-Size)    : GDSF assigns a priority to cached documents based on the cost of a cache miss and the size
#           of the document. Documents with the lowest priority are removed first.
#
# == Examples
#
#    class { "apache2::mod::cache": activated  => true } ->
#    class { "apache2::mod::mem_cache":
#        activated           => true,
#        size                => 10240,  # KBytes
#        max_object_count    => 5000,
#        min_object_size     => 10,     # bytes
#        max_object_size     => 10000,  # bytes
#        removal_algorithm   => "LRU",  # GDSF or LRU
#    }
#
################################################################################
class apache2::mod::mem_cache (
  $activated         = true,
  $size              = 4096,
  $max_object_count  = 1009,
  $min_object_size   = 1,
  $max_object_size   = 10000,
  $removal_algorithm = 'GDSF') {
  if ($removal_algorithm != 'GDSF') and ($removal_algorithm != 'LRU') {
    fail("The parameter removal_algorithm in ${module_name} module only support GDSF or LRU values and not ${removal_algorithm}")
  }
  case $apache2::params::apache_version {
    /(2.2)/ : {
      apache2::module { 'mem_cache':
        activated          => $activated,
        conf_file          => true,
        conf_file_template => true,
        require            => [
          Package['httpd'],
          Class['apache2::mod::cache']],
      }
    }
    default : {
      fail("The ${module_name} module is not supported un Apache [${apache2::params::apache_version}] version, please use cache_disk module instead")
    }
  }
}
