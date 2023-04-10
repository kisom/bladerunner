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

bazel_setup () {
    local BAZEL_BIN="$(command -v bazel)"
    local BUILDIFIER_BIN="$(command -v buildifier)"
    local BAZELISK_VERSION="1.16.0"

    if [ "$(uname -s)" != "Linux" ]
    then
	    echo '[!] godeb is only supported on Linux.' > /dev/stderr
	    exit 1
    fi

    case "$(uname -m)" in
	    amd64) ARCH="amd64" ;;
	    arm64) ARCH="arm64" ;;
        x86_64) ARCH="amd64" ;;
        *)
	        echo "[!] $(uname -m) is an unsupported architecture." > /dev/stderr
	        echo '[!] supported architectures: amd64, arm64' > /dev/stderr
            exit 1
	    ;;
    esac

    local BAZELISK_URL="https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/bazelisk-linux-${ARCH}"
    local BAZELISK_DBIN="${BAZELISK_URL##*/}"
    
    if [ ! -x "${INSTALL_DIR}/bazelisk" ]
    then
        pushd /tmp
        curl -LO "${BAZELISK_URL}"
        chmod +x "${BAZELISK_DBIN}"
        $SUDO mv "${BAZELISK_DBIN}" "${INSTALL_DIR}/bazelisk"
        popd
    fi

    local BUILDTOOLS_REPO="https://github.com/bazelbuild/buildtools"

    if [ ! -x "${INSTALL_DIR}/buildifier" ]
    then
        pushd /tmp
        git clone "${BUILDTOOLS_REPO}"
        pushd "${BUILDTOOLS_REPO##*/}"
        bazelisk build //buildifier
        sudo mv bazel-bin/buildifier/buildifier_/buildifier "${INSTALL_DIR}/buildifier"
        popd
        popd
    fi
}

preflight
bazel_setup