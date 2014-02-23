#!/bin/sh

LOG=/var/log/cloud-user-script.log
PUPPET_INTERNAL_NAME=puppet.int.aws.ledcom.ch
PUPPET_EXTERNAL_NAME=puppet.aws.ledcom.ch

echo 'create a few needed files'

mkdir -p /etc/facter/facts.d/

cat > /etc/facter/facts.d/server_role.txt << EOF
server_role=puppetmaster
EOF

cat > /etc/r10k.yaml << EOF
:cachedir: '/var/cache/r10k'
:sources:
  :plops:
    remote: 'git@github.com:gehel/puppetmaster.git'
    basedir: '/etc/puppet/environments'
:purgedirs:
  - '/etc/puppet/environments'
EOF

mkdir -p /etc/puppet/
cp /vagrant/files/private_key.pkcs7.pem /etc/puppet/private_key.pkcs7.pem
cp /vagrant/files/public_key.pkcs7.pem /etc/puppet/public_key.pkcs7.pem

mkdir /root/.ssh
cp /vagrant/files/id_rsa /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh-keyscan github.com >> /root/.ssh/known_hosts

echo "127.0.0.1       ${PUPPET_INTERNAL_NAME} ${PUPPET_EXTERNAL_NAME}" >> /etc/hosts

echo 'make sure everything is up to date'
wget http://apt.puppetlabs.com/puppetlabs-release-`lsb_release -cs`.deb
dpkg -i puppetlabs-release-`lsb_release -cs`.deb
apt-get update
apt-get dist-upgrade -y

echo 'install puppet and dependencies'
/usr/sbin/locale-gen enUS.utf8
export LANGUAGE=en_US.utf8
export LC_ALL=en_US.utf8
export LANG=en_US.utf8

apt-get install -y unattended-upgrades puppetmaster git rubygems ruby-systemu ruby-log4r libsystemu-ruby liblog4r-ruby
gem install r10k
gem install hiera-eyaml

/usr/local/bin/r10k -v info deploy environment

#echo 'remove current puppet certificate, and regenerated with correct alt_names'
#service puppetmaster stop
#puppet cert clean --all `hostname -f`
#puppet ca generate --dns-alt-names ${PUPPET_EXTERNAL_NAME},${PUPPET_INTERNAL_NAME} `hostname -f`

#service puppetmaster start
service puppetmaster stop

echo 'puppet run to ensure basic configuration'
puppet apply \
  --modulepath=/etc/puppet/environments/production/modules:/etc/puppet/environments/production/dist \
  --hiera_config=/etc/puppet/environments/production/hiera.yaml \
  /etc/puppet/environments/production/site/site.pp

echo 'full puppet run to ensure server is completely created'
sleep 30
puppet agent -t

echo 'Installation completed'

