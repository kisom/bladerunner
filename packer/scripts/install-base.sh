#!/usr/bin/env bash

set -euxo pipefail

echo "==> Setting nameserver"
rm /etc/resolv.conf
echo 'nameserver 8.8.8.8' > /etc/resolv.conf

echo "==> installing base updates"
apt-get -y update
apt-get -y install ansible apt-transport-https ca-certificates wpasupplicant
apt-get -y clean