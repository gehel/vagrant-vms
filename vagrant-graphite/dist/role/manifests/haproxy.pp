class role::haproxy {
  apt::repository { 'wheezy-backports':
    url        => 'http://http.us.debian.org/debian',
    distro     => 'wheezy-backports',
    repository => 'main',
  }

  class { '::haproxy':
    config_file_content => template('role/haproxy/haproxy.cfg.erb'),
  }
      firewall { "haproxy_tcp_80":
        source      => '0.0.0.0/0',
        destination => $ipaddress_eth1,
        protocol    => 'tcp',
        port        => 80,
        action      => 'allow',
        direction   => 'input',
        tool        => $::firewall_tool,
        enable      => true,
      }
}