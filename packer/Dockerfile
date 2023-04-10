# Set up a packer image in Docker.
FROM ubuntu:22.04
LABEL org.opencontainers.image.authors=kyle@imap.cc

RUN apt-get update && apt-get -y install git curl sudo
RUN git clone https://git.wntrmute.dev/kyle/bladerunner 
RUN bladerunner/tools/install-go.sh

ADD . packer
WORKDIR packer
RUN ./install-packer.sh

ENTRYPOINT ["/usr/bin/env", "bash"]
