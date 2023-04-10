#!/usr/bin/env bash

set -eux

PACKER_VERSION=1.8.6
INSTALL_DIR=/usr/local/bin
ARCH=amd64
PACKER_FILE=packer_${PACKER_VERSION}_linux_${ARCH}
UPSTREAM="https://github.com/mkaczanowski/packer-builder-arm"
UPGRADE="false"

prep () {
    mkdir -p build
    pushd build
}

install_packer () {
    if [ -x ${INSTALL_DIR}/packer ]
    then
	return 0
    fi

    curl -LO https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_FILE}.zip
    unzip ${PACKER_FILE}
    sudo mv packer ${INSTALL_DIR}/
    rm ${PACKER_FILE}.zip
}

install_packer_builder_arm () {
    if [ -x "${INSTALL_DIR}/packer-builder-arm" -a -z "${UPGRADE}" ]
    then
	return 0
    fi

    git clone "${UPSTREAM}"
    pushd "${UPSTREAM##*/}"
    go mod download
    go build
    sudo mv packer-builder-arm ${INSTALL_DIR}/
    popd
}

cleanup {
    popd
}

prep
install_packer
install_packer_builder_arm
cleanup
