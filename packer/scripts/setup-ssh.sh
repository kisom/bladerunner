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
esac

apt-get -y install openssh-server
