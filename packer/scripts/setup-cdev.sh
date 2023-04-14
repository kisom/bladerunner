#!/usr/bin/env bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "[+] installing cdev node packages"
apt-get --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y install dnsmasq picocom wpasupplicant

echo "[+] installing tailscale"
curl -fsSL https://tailscale.com/install.sh | sh