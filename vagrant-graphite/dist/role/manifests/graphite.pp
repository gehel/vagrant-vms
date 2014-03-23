class role::graphite {
  class { 'apache': }

  package { 'python-pip': } ->
  class { '::graphite':
    secret_key  => 'toto',
    server_name => $::hostname,
  }

}