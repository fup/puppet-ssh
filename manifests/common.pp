class ssh::common {
  File {
    owner => 'root',
    group => 'root',
  }

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  file {
    $ssh::params::sh_tmp_dir:
      ensure  => directory;
    "${ssh::params::sh_tmp_dir}/authorized_keys.d":
      ensure  => directory,
      purge   => 'true',
      recurse => 'true';
    "${ssh::params::sh_tmp_dir}/authorized_keys.d/fragment":
      ensure  => directory,
      purge   => 'true',
      recurse => 'true';
    "${ssh::params::sh_helper_bin_dir}/rebuild_authorized_keys":
      ensure  => 'file',
      mode    => '0755',
      content => template('ssh/bin/rebuild_authorized_keys.erb');
  }

  exec { "rebuild-authorized_keys":
    command     => "${ssh::params::sh_helper_bin_dir}/rebuild_authorized_keys",
    refreshonly => 'true',
  }
}
