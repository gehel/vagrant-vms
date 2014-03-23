class role::graphite {
  class { 'apache': }

  package { 'python-pip': } ->
  class { '::graphite':
    secret_key  => 'toto',
    server_name => 'graphite',
  }

  file { '/etc/apache2/sites-enabled/000-default':
    ensure => 'absent',
    notify => $apache::manage_service_autorestart,
  }

}