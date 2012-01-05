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
  -> anchor { 'ssh::server::begin': }
  -> anchor { 'ssh::server::end': }
  -> anchor { 'ssh::client::begin': }
  -> anchor { 'ssh::client::end': }
  -> anchor { 'ssh::end': }

  if $server == 'true' {
    class { 'ssh::server':
      require => Anchor['ssh::server::begin'],
      before  => Anchor['ssh::server::end'],
    }
  }

  if $client == 'true' {
    class { 'ssh::client': 
      require => Anchor['ssh::client::begin'],
      before  => Anchor['ssh::client::end'],
    }
  }
}
