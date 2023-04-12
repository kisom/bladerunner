#!/usr/bin/env bash

set -euxo pipefail

INSTALL_DIR="/usr/local/bin"
SUDO=sudo

preflight () {
    if [ "$(whoami)" = "root" ]
    then
        SUDO=""
    fi
}

apt_packages () {
    $SUDO apt-get update
    $SUDO apt-get -y install git bash curl sudo build-essential unzip \
                             qemu-user-static e2fsprogs dosfstools    \
                             libarchive-tools xz-utils
}

preflight
apt_packages