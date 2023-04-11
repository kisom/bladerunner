#!/usr/bin/env bash

set -euxo pipefail

PACKER_IMAGE_NAME="bladerunner/packer:latest"

preflight () {
    if [ -z "$(docker image ls -q ${PACKER_IMAGE_NAME})" ]
    then
        docker image build -t "${PACKER_IMAGE_NAME}" .
    fi
}

run_image () {
    # privileged is required for loopback devices
    docker run --privileged=true -i -t -v build:/packer/build -v /dev:/dev ${PACKER_IMAGE_NAME} -c "./build-image.sh"
}

preflight
run_image
