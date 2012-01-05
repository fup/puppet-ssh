class ssh::client::package {
  package { $ssh::params::sh_client_packages:
    ensure => present,
  }
}
