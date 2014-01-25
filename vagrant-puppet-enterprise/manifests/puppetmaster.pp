$puppi = true
$monitor = true
$monitor_tool = ['puppi']

class { 'puppi': }

class { 'rundeck::node': }


class { 'r10k':
  provider => 'pe_gem',
  remote => 'https://github.com/gehel/puppetmaster.git',
} -> cron { 'r10k-deploy-env':
  command => '/usr/bin/r10k deploy environment -p',
  minute  => '*/5',
}

class { 'sudo':
}

$rundeck_node_username = 'rundeck_node'

sudo::directive { 'rundeck-r10k': content => "${rundeck_node_username} ALL=NOPASSWD: /usr/local/bin/r10k\n", }

sudo::directive { 'rundeck-puppet': content => "${rundeck_node_username} ALL=NOPASSWD: /usr/bin/puppet\n", }