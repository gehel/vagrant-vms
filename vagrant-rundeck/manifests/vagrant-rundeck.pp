# Rundeck repo is not signed at the moment, so we accept that at the moment
apt::conf { 'allow-unauthenticated': content => 'APT::Get::AllowUnauthenticated yes;', }

class { 'rundeck':
  manage_repos => true,
  projects     => {
    'test-project-1' => {
      'jobs' => {
        'test-job-1' => {
          'format' => 'yaml',
          'source' => '/vagrant/files/test-job-1.yaml'
        }
      }
    }
  }
}
