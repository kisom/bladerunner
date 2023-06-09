#!/usr/bin/env bash

set -euxo pipefail

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]
then
    set -euxo pipefail
    RUN_MAIN=yes
else
    RUN_MAIN=no
fi

IMAGE_TYPE="${1:-ubuntu}"
PACKER_BUILD_FILE="${2:-}"
SKIP_LOCAL_CACHE="${SKIP_LOCAL_CACHE:-no}"

errmsg () {
    echo "$@" > /dev/stderr
}

IMAGE_TYPE="${1:-cnode}"

preflight () {
    case "${IMAGE_TYPE}" in
        cdev) PACKER_BUILD_FILE="boards/cm4-cdev-ubuntu-22.04.2.json" ;;    
        cnode)  PACKER_BUILD_FILE="boards/cm4-cnode-ubuntu-22.04.2.json" ;;
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
            errmsg "    - cdev"
            errmsg "    - cnode"
            errmsg "    - custom path/to/board/file"
            exit 1
            ;;
    esac
}

cache_remote_url () {
    if [ "${SKIP_LOCAL_CACHE}" = "yes" ]
    then
        echo "[+] skipping fetch of remote file: SKIP_LOCAL_CACHE=yes"
        return 0
    fi

    local REMOTE_IMAGE_URL="$(jq '.builders[0].file_urls' ${PACKER_BUILD_FILE} | grep https | tr -d ' \",')"
    local CACHED_FILE="$(jq '.builders[0].file_urls' ${PACKER_BUILD_FILE} | grep -v https | grep \" | tr -d ' \",')"
    if [ -z "${CACHED_FILE}" ]
    then
        echo "[+] skipping fetch of remote file: no local file provided"
        return 0
    fi
    
    if [ -z "${REMOTE_IMAGE_URL}" ]
    then
        echo "[+] skipping fetch of remote file: no remote file provided"
        return 0
    fi

    if [ -s "${CACHED_FILE}" ]
    then
        echo "[+] skipping fetch of remote file: file already exists. To force redownloading,"
        echo "    run the following:"
        echo ""
        echo "        rm ${CACHED_FILE}"
        return 0
    fi

    curl -fsSL -o "${CACHED_FILE}" "${REMOTE_IMAGE_URL}" 
}

build_image () {
    sudo packer build ${PACKER_BUILD_FILE}
}

main () {
    preflight
    cache_remote_url
    build_image
}

if [[ "${RUN_MAIN}" = "yes" ]]
then
    main
fi
