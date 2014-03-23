class role::memcached {
  class { '::memcached':
    config_file_template => 'role/memcached/memcached.conf.erb',
  }
  collectd::plugin { 'memcached': config_file_content => template('role/collectd/memcached.conf.erb'), }
}