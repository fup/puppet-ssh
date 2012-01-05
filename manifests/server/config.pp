class ssh::server::config {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/ssh/sshd_config':
    ensure => present,
    content => template('ssh/etc/ssh/sshd_config.erb'),
  }
}
