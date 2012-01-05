class ssh::server::package {
  package { $ssh::params::sh_server_packages:
    ensure => present,
  }
}
