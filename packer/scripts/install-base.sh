#!/usr/bin/env bash

set -euxo pipefail

echo "==> Setting nameserver"
echo 'nameserver 8.8.8.8' > /etc/resolv.conf

echo "==> installing base updates"
apt-get -y update
apt-get -y install ansible apt-transport-https ca-certificates
apt-get -y clean