class ssh::server {
  include stdlib
  include ssh::params

  anchor { 'ssh::server::start': }
  -> class { 'ssh::server::package': }
  -> class { 'ssh::server::config': }
  ~> class { 'ssh::server::service': }
  -> anchor { 'ssh::server::end': }
}
