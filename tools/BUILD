load("@io_bazel_rules_docker//container:container.bzl", "container_image")
# load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")

container_image(
    name = "bladerunner/tools",
    base = "@alpine_linux_amd64//image",
    cmd = ["World"],
    entrypoint = [
        "echo",
        "Hello",
    ],
    env = {
        "envVar": "My environment variable",
        "xyz": "321",
    },
    files = [
        "//extended/image_data:Data_file.txt",
        "//extended/image_data:More_data.txt",
        "//extended/image_data:file_to_copy.txt",
    ],
    labels = {
        "desc": "Description for version 7.7",
        "version": "7.7",
    },
    symlinks = {
        "/usr/More_data.txt": "/More_data.txt",
    },
    tars = ["//extended/image_data:tarfile.tar"],
    volumes = [
        "/myVol1",
        "/usr/myVol2",
    ],
)