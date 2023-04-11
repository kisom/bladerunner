# bladerunner/packer

This directory contains the tooling to build raspberry pi images using
packer.

- `install-packer.sh` will set up packer and packer-builder-arm. It will 
  also install additional dependencies assuming a Debian-ish system. This
  is mostly intended for use in containers, as my Ansible config should
  cover this for hardware.
- `run-docker.sh` runs the builder in Docker.


### Resources

- [Build a Raspberry Pi image with Packer](https://linuxhit.com/build-a-raspberry-pi-image-packer-packer-builder-arm/)
