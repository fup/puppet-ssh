class ssh(
  $server = '',
  $client = ''
){
  include stdlib
  include ssh::params

  if $server == '' { $REAL_server = $ssh::params::sh_server }
  else { $REAL_server = $server }

  if $client == '' { $REAL_client = $ssh::params::sh_client }
  else { $REAL_client = $client }

  anchor { 'ssh::begin': }
  -> anchor { 'ssh::server_init::begin': }
  -> anchor { 'ssh::server_init::end': }
  -> anchor { 'ssh::client_init::begin': }
  -> anchor { 'ssh::client_init::end': }
  -> anchor { 'ssh::end': }

  if $server == 'true' {
    class { 'ssh::server':
      require => Anchor['ssh::server_init::begin'],
      before  => Anchor['ssh::server_init::end'],
    }
  }

  if $client == 'true' {
    class { 'ssh::client': 
      require => Anchor['ssh::client_init::begin'],
      before  => Anchor['ssh::client_init::end'],
    }
  }
}
