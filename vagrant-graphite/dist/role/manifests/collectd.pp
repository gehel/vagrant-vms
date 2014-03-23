class role::collectd {
  class { '::collectd':
    config_file_content => template('role/collectd/collectd.conf.erb'),
  }

  collectd::plugin { 'write_graphite': config_file_content => template('role/collectd/write_graphite.conf.erb'), }

}