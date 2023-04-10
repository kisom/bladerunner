load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

## C++ dependencies
http_archive(
    name = "gtest",
    url = "https://github.com/google/googletest/archive/release-1.10.0.zip",
    sha256 = "94c634d499558a76fa649edb13721dce6e98fb1e7018dfaeba3cd7a083945e91",
    build_file = "@//:gtest.BUILD",
)

## OCI
# see https://github.com/bazel-contrib/rules_oci/releases/tag/v0.3.9
http_archive(
    name = "rules_oci",
    sha256 = "f6125c9a123a2ac58fb6b13b4b8d4631827db9cfac025f434bbbefbd97953f7c",
    strip_prefix = "rules_oci-0.3.9",
    url = "https://github.com/bazel-contrib/rules_oci/releases/download/v0.3.9/rules_oci-v0.3.9.tar.gz",
)

load("@rules_oci//oci:dependencies.bzl", "rules_oci_dependencies")

rules_oci_dependencies()

load("@rules_oci//oci:repositories.bzl", "LATEST_CRANE_VERSION", "LATEST_ZOT_VERSION", "oci_register_toolchains")

oci_register_toolchains(
    name = "oci",
    crane_version = LATEST_CRANE_VERSION,
    # Uncommenting the zot toolchain will cause it to be used instead of crane for some tasks.
    # Note that it does not support docker-format images.
    # zot_version = LATEST_ZOT_VERSION,
)

# Optional, for oci_tarball rule
load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()