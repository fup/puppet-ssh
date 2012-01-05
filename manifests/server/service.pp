class ssh::server::service {
  service { $ssh::params::sh_server_daemon:
    ensure     => 'running',
    enable     => 'true',
    hasstatus  => 'true',
    hasrestart => 'true',
  }
}
