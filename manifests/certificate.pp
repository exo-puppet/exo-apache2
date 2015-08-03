define apache2::certificate (
  $ssl_cert_file       = "false",
  $ssl_cert_key_file   = "false",
  $ssl_cert_chain_file = "false",
) {

  $ssl_cert_name            = $name
  $ssl_cert_file_name       = "${apache2::params::certs_dir}/${ssl_cert_name}-cert.cer"
  $ssl_cert_key_file_name   = "${apache2::params::certs_dir}/${ssl_cert_name}-cert.key"
  $ssl_cert_chain_file_name = "${apache2::params::certs_dir}/${ssl_cert_name}-chain.txt"

  ####################################
  # Add SSL Certificats if specified
  ####################################
  file { $ssl_cert_file_name:
    ensure  => $ssl_cert_file ? {
      "false"   => absent,
      default => file
    },
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => $ssl_cert_file ? {
      "false"   => undef,
      default => $ssl_cert_file,
    },
    require => Class['apache2::install'],
    notify  => Class['apache2::service'],
  } -> file { $ssl_cert_key_file_name:
    ensure  => $ssl_cert_key_file ? {
      "false"   => absent,
      default => file
    },
    owner   => root,
    group   => root,
    mode    => '0644',
    source  =>  $ssl_cert_key_file ? {
      "false"   => undef,
      default => $ssl_cert_key_file,
    },
    require => Class['apache2::install'],
    notify  => Class['apache2::service'],
  } -> file { $ssl_cert_chain_file_name:
    ensure  => $ssl_cert_chain_file ? {
      "false"   => absent,
      default => file
    },
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => $ssl_cert_chain_file ? {
      "false"   => undef,
      default => $ssl_cert_chain_file,
    },
    require => Class['apache2::install'],
    notify  => Class['apache2::service'],
  }

}
