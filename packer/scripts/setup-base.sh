#!/usr/bin/env bash

set -euxo pipefail

echo "[+] setting nameserver"
rm /etc/resolv.conf
echo 'nameserver 8.8.8.8' > /etc/resolv.conf

echo "[+] installing base packages"
apt-get -y update
apt-get -y install ansible apt-transport-https ca-certificates rng-tools

echo "[+] installing TPM tooling"
apt-get -y install libtpms-dev tpm2-tools tss2

echo "[+] removing unused packages"
apt-get -y remove fake-hwclock snapd

echo "[+] cleaning apt install"
apt-get -y clean
apt-get -y autoremove
