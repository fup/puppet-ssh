class ssh::client::config {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/ssh/ssh_config':
    ensure => present,
    content => template('ssh/etc/ssh/ssh_config.erb'),
  }
}
