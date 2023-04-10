# Set up a packer image in Docker.
FROM ubuntu:22.04
LABEL org.opencontainers.image.authors=kyle@imap.cc

ONBUILD RUN apt-get update && apt-get install git
ONBUILD RUN git clone https://git.wntrmute.dev/kyle/bladerunner 
ONBUILD RUN bladerunner/tools/install-go.sh

ADD . packer

ENTRYPOINT ["/usr/bin/env", "bash"]
