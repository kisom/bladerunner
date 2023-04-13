#!/usr/bin/env bash

set -euxo pipefail

source /etc/os-release

case "${ID}" in
	ubuntu)
		SYSTEM_USER=ubuntu
		SYSTEM_HOME=/home/${SYSTEM_USER}
		;;
	*)
		SYSTEM_USER=root
		SYSTEM_HOME=/root
		;;

echo "[+] setting up ssh"
apt-get -y install openssh-server

SSH_DIR="${SYSTEM_HOME}/.ssh"
mkdir -p ${SYSTEM_HOME}/.ssh
chmod 0700 ${SSH_DIR}

mv /tmp/authorized_keys ${SSH_DIR}/authorized_keys
chmod 0644 ${SSH_DIR}/authorized_keys

