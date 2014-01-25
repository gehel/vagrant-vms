#!/bin/bash

PUPPET_VERSION=3.1.1
FILES_DIR=/vagrant/files/
ANSWERS=${FILES_DIR}/answers
BASE_NAME=puppet-enterprise-${PUPPET_VERSION}-el-6-x86_64
TAR_FILENAME=${BASE_NAME}.tar.gz
TAR_FILE=${FILES_DIR}/${TAR_FILENAME}
TMP=/tmp
EXTRACTED_DIR=${TMP}/${BASE_NAME}

if [ -d "/opt/puppet" ]; then
  echo "Puppet Enterprise seems to be already installed."
  echo "Nothing to do, exiting..."
  exit 0
fi

echo "Untar distribution"
tar xzvf $TAR_FILE -C $TMP

echo "Installing Puppet Enterprise"
${EXTRACTED_DIR}/puppet-enterprise-installer -a ${ANSWERS}

echo "Creating puppet sysmlink in /usr/bin as there is a problem with the PATH used by vagrant"
ln -s /usr/local/bin/puppet /usr/bin/puppet

echo "Remove temporay files"
rm -rf ${EXTRACTED_DIR}

