stage { 'yum': before => Stage['main'], }
class { 'yum':
  before => Stage['rvm-install'],
  stage  => 'yum',
} ->
yum::managed_yumrepo { 'jenkins':
  descr    => 'Jenkins - ',
  baseurl  => 'http://pkg.jenkins-ci.org/redhat',
  enabled  => 1,
  gpgcheck => 1,
  gpgkey   => 'http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key',
  priority => 1,
} ->
package { 'java-1.7.0-openjdk-devel': ensure => present, } ->
class { 'jenkins': repo => 0, }

user { 'jenkins':
  ensure => present,
  home   => '/var/lib/jenkins',
}

jenkins::plugin {
  'analysis-core':
  ;

  'any-buildstep':
  ;

  'build-pipeline-plugin':
  ;

  'conditional-buildstep':
  ;

  'dashboard-view':
  ;

  'flexible-publish':
  ;

  'git-client':
  ;

  'jquery':
  ;

  'parameterized-trigger':
  ;

  'run-condition':
  ;

  'token-macro':
  ;

  'warnings':
  ;
}

class { 'jenkins::plugin::git':
  manage_config => true,
}

class { 'rvm':
  version => '1.22.4',
} ->
rvm::system_user { 'jenkins': } ->
rvm_system_ruby { 'ruby-1.9.2-p290':
  ensure      => 'present',
  default_use => true,
} ->
rvm_gemset { "ruby-1.9.2-p290@puppet": ensure => present, } ->
rvm_gem {
  'ruby-1.9.2-p290@puppet/rake':
    ensure => '10.1.0';

  'ruby-1.9.2-p290@puppet/bundler':
    ensure => '1.3.5';

  'ruby-1.9.2-p290@puppet/ci_reporter':
    ensure => '1.9.0';

  'ruby-1.9.2-p290@puppet/puppetlabs_spec_helper':
    ensure => '0.4.1';

  'ruby-1.9.2-p290@puppet/cucumber':
    ensure => '1.3.7';

  'ruby-1.9.2-p290@puppet/extensions':
    ensure => '0.6.0';

  'ruby-1.9.2-p290@puppet/puppet-blacksmith':
    ensure => '2.0.2';

  'ruby-1.9.2-p290@puppet/puppet-lint':
    ensure => '0.3.2';

  'ruby-1.9.2-p290@puppet/puppet-module':
    ensure => '0.3.4';
}

class { 'jenkins_jobs':
  require => Anchor['jenkins::end'],
} ->
jenkins_jobs::puppet { 'puppet-mysql':
  name             => 'puppet-mysql',
  description      => 'Builds puppet-mysql',
  git_url          => 'https://github.com/example42/puppet-mysql.git',
  concurrent_build => true,
}
jenkins_jobs::puppet_deploy { 'puppet-deploy-dev':
  name => 'puppet-deploy-dev',
  description => 'Deploy Puppet module to DEV',
  target_environment => 'DEV',
  downstream_job => 'puppet-deploy-stg',
}
jenkins_jobs::puppet_deploy { 'puppet-deploy-stg':
  name => 'puppet-deploy-stg',
  description => 'Deploy Puppet module to STG',
  target_environment => 'STG',
  downstream_job => 'puppet-deploy-prod',
}
jenkins_jobs::puppet_deploy { 'puppet-deploy-prod':
  name => 'puppet-deploy-prod',
  description => 'Deploy Puppet module to PROD',
  target_environment => 'PROD',
}

# nice to have
package { 'bash-completion': ensure => present, }

service { 'iptables': ensure => stopped, }
