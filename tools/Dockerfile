# Set up a container with the tooling installed.
FROM ubuntu:22.04
LABEL org.opencontainers.image.authors=kyle@imap.cc

ADD . tools
RUN tools/install-dependencies.sh
RUN tools/install-go.sh
RUN tools/install-bazel.sh

ENTRYPOINT ["/usr/bin/env", "bash"]
