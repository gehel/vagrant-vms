class { 'yum': }

class { 'cntlm':
  proxies     => ['10.217.112.41:8080', '10.217.112.42:8080',],
}