# Set up a packer image in Docker.
FROM ubuntu:22.04
LABEL org.opencontainers.image.authors=kyle@imap.cc

RUN apt-get update && apt-get -y install git bash curl sudo

ADD . tools
RUN tools/install-go.sh

ENTRYPOINT ["/usr/bin/env", "bash"]
