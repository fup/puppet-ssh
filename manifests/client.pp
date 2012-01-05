class ssh::client {
  include stdlib
  include ssh::params

  anchor { 'ssh::client::start': }
  -> class { 'ssh::client::package': }
  -> class { 'ssh::client::config': }
  -> anchor { 'ssh::client::end': }
}
