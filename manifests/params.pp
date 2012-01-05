class ssh::params {
  $sh_server = 'true'
  $sh_client = 'true'
  $sh_tmp_dir = '/tmp/ssh'

  case $::operatingsystem {
    fedora,redhat,centos,oel: {
      $sh_client_packages = ['openssh', 'openssh-clients']
      $sh_server_packages = ['openssh-server']
      $sh_server_daemon = 'sshd'
    }
  }
}
