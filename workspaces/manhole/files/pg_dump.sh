#!/bin/bash -

set -o errexit

# Install Ansible and Git
apt-get update -y && apt-get install -y ansible git

# Clone Git repo
git clone https://github.com/dabr-ca/config

# Run pg_dump role
pushd config
ansible-playbook role.yaml -i localhost, -e target=localhost -e role=pg_dump -c local

# Run pg_dump service
#systemctl start pg_dump.service

# Shutdown to terminate the EC2 instance
#poweroff
