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
    $SUDO apt-get -y install git bash curl sudo build-essential
}

preflight
apt_packages