$puppi = true
$monitor = true
$monitor_tool = ['puppi']
$firewall = true
$firewall_tool = 'iptables'
$firewall_dst = $::ipaddress_eth1

$carbon_instance_name = $::hostname ? {
  'graphite1' => 'a',
  'graphite2' => 'b',
  default     => undef,
}

$graphite_cluster_servers = '[ "192.168.50.21:80", "192.168.50.22:80" ]'

$carbon_carbon_relay_enabled = true
$carbon_relay_destinations = '192.168.50.21:2004:a, 192.168.50.22:2004:b'

$graphite_carbonlink_hosts = '[ "192.168.50.21:7002:a", "192.168.50.22:7002:b" ]'
$graphite_memcache_hosts = '[ \'10.10.10.10:11211\' ]'

$graphite_db_name = 'graphite'
$graphite_db_engine = 'django.db.backends.mysql'
$graphite_db_user = 'graphite'
$graphite_db_password = 'graphite'
$graphite_db_host = 'mysql'
$graphite_db_port = '3306'

node default {
  class { 'apt': }

  class { 'openssh': }

  host { 'mysql': ip => '192.168.50.10', }

  host { 'graphite1': ip => '192.168.50.21', }

  host { 'graphite2': ip => '192.168.50.22', }

  host { 'memcached1': ip => '192.168.50.31', }

  host { 'haproxy': ip => '192.168.50.200', }


  $graphite_host = 'haproxy'
  $graphite_port = '2013'

  class {'role::collectd':}
}

node /^graphite\d+$/ inherits default {
  class { 'role::graphite': }
}

node /^memcached\d+$/ inherits default {
  class { 'role::memcached': }
}

node /^mysql.*$/ inherits default {
  class { 'role::mysql': }
}

node /^haproxy.*$/ inherits default {
  class { 'role::haproxy': }
}
