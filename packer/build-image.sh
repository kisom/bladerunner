#!/usr/bin/env bash

set -euxo pipefail

IMAGE_TYPE="${1:-ubuntu}"
PACKER_BUILD_FILE="${2:-}"

errmsg () {
    echo "$@" > /dev/stderr
}

preflight () {
    case "${IMAGE_TYPE}" in
        ubuntu) PACKER_BUILD_FILE="boards/pi-cm4-ubuntu-22.04.2.json" ;;
        raspbian) PACKER_BUILD_FILE="boards/raspberry-pi/raspios-lite-arm.json" ;;
        custom)
            if [ -z "${PACKER_BUILD_FILE}" ]
            then
                errmsg "[!] custom board requires a board file path"
                exit 1
            fi
            ;;
        *)
            errmsg "[!] invalid image type ${IMAGE_TYPE}."
            errmsg "[!] valid image types are"
            errmsg "    - raspbian"
            errmsg "    - ubuntu"
            errmsg "    - custom path/to/board/file"
            exit 1
            ;;
    esac
}

build_image () {
    sudo packer build ${PACKER_BUILD_FILE}
}

preflight
build_image

