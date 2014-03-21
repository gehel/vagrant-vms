$puppi = true
$monitor = true
$monitor_tool = ['puppi']

class { 'apt': }

class { 'apache': }

package { 'python-pip': } ->
class { 'graphite':
  secret_key => 'toto',
}
