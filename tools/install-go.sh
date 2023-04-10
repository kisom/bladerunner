#!/usr/bin/env bash

set -euxo pipefail

INSTALL_DIR="/usr/local/bin"
GOVERSION=1.20.3
ARCH=amd64

preflight () {

    if [ "$(uname -s)" != "Linux" ]
    then
	echo '[!] godeb is only supported on Linux.' > /dev/stderr
	exit 1
    fi

    case "$(uname -m)" in
	amd64) ARCH="amd64" ;;
	arm64) ARCH="arm64" ;;
	*)
	    echo "[!] $(uname -m) is an unsupported architecture." > /dev/stderr
	    echo '[!] supported architectures: amd64, arm64' > /dev/stderr
        exit 1
	    ;;
    esac
}

install_godeb () {
    local GODEB=https://godeb.s3.amazonaws.com/godeb-${ARCH}.tar.gz
    if [ -x "${INSTALL_DIR}/godeb" ]
    then
	return 0
    fi

    local GODEB_ARCHIVE="${GODEB##*/}"

    pushd /tmp
    curl -LO "${GODEB}"
    tar xzf "${GODEB_ARCHIVE}"
    sudo mv godeb "${INSTALL_DIR}/"
    rm "${GODEB_ARCHIVE}"
    popd
}

install_go {
    pushd /tmp
    echo '[*] installing go - this will request sudo'
    godeb install "${GOVERSION}"
    # note: deliberately leaving this in /tmp for inspection
    # if needed.
    popd
}
