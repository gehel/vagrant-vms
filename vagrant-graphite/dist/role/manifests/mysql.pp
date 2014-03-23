class role::mysql {
  class { '::mysql': template => 'role/mysql/my.cnf.erb', }

  mysql::grant { $::graphite_db_name:
    mysql_privileges => 'ALL',
    mysql_password   => $::graphite_db_password,
    mysql_db         => $::graphite_db_name,
    mysql_user       => $::graphite_db_user,
    mysql_host       => '%',
  }

  collectd::plugin { 'mysql': config_file_content => template('role/collectd/mysql.conf.erb'), }
}