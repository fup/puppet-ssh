define ssh::authorized_key(
  $ensure = 'present',
  $target = '',
  $user
) {
  include ssh::params
  include ssh::common

  File {
    owner => 'root',
    group => 'root',
    mode  => '0600',
  }

  if $target == '' and $user != 'root' { $REAL_target = "/home/${user}/.ssh/authorized_keys" }
  elsif $target == '' and $user == 'root' { $REAL_target = '/root/.ssh/authorized_keys' }
  else { $REAL_target = $target }

  $unique_id = md5($name)
  $auth_key_file = "${ssh::params::sh_tmp_dir}/authorized_keys.d/${user}"

  file { "${ssh::params::sh_tmp_dir}/authorized_keys.d/fragment/${user}-${unique_id}":
    ensure  => $ensure,
    content => "${name}\n",
    notify  => Exec["rebuild-authorized_keys"],
  }

  #  exec { "sync-authorized_keys-${user}":
  #    command     => "cp -rf ${auth_key_file} ${REAL_target} && chown ${user} ${auth_key_file}",
  #    unless      => "diff ${REAL_target} ${auth_key_file}",
  #    require     => [ User[$user], Exec["install-authorized_keys-${user}"] ],
  #  }
}
