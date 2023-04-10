#!/usr/bin/env bash

set -euxo pipefail

./install-dependencies.sh
./install-go.sh
./install-bazel.sh