class role::haproxy {
  apt::repository { 'wheezy-backports':
    url        => 'http://http.us.debian.org/debian',
    distro     => 'wheezy-backports',
    repository => 'main',
  }

  class { '::haproxy':
  }
}