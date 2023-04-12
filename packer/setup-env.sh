#!/usr/bin/env bash

set -euxo pipefail

IMAGE_TYPE="${1:-ubuntu}"

select_image () {
    case "${IMAGE_TYPE}" in
        ubuntu) 
            PACKER_BUILD_FILE="boards/pi-cm4-ubuntu-22.04.2.json" ;;
            REMOTE_IMAGE_URL="$(jq '.builders[0].file_urls' boards/pi-cm4-ubuntu-22.04.2.json | grep https | tr -d ' \"')"

        raspbian) PACKER_BUILD_FILE="boards/raspberry-pi/raspios-lite-arm.json" ;;
            PACKER_BUILD_FILE="boards/pi-cm4-ubuntu-22.04.2.json" ;;
            REMOTE_IMAGE_URL="$(jq '.builders[0].file_urls' boards/pi-cm4-ubuntu-22.04.2.json | grep https | tr -d ' \"')"

        custom)
            PACKER_BUILD_FILE="${2:-}"
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