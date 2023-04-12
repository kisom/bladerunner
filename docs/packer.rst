packer
======

`packer <https://www.packer.io/>`_ is used to generate the base images for the cluster.

Quick workflow
--------------

All of these instructions assume you are in the ``packer`` directory.

The first time, make sure dependencies are installed and run ``./install-packer.sh``.

1. If updates to the image spec are needed, edit `ubuntu-boards.yml` and run 

.. code-block:: shell
    
    bazel run //packer:ubuntu-board-gen -f $(pwd)/ubuntu-boards.yml -o $(pwd)/boards

This will place the board with a default name in the ``boards`` directory.

2. Run ``./build-imagesh``. The image will be in the ``build/`` directory.

Build scripts
-------------

There are a few scripts that are used in building a packer image. In general,
the workflow looks like:

1. ``install-packer.sh``
2. ``build-image.sh``

Alternatively, you can run ``run-docker.sh`` to optionally build a container
from the provided Dockerfile and then run it.

``install-packer.sh``
^^^^^^^^^^^^^^^^^^^^^^

``install-packer.sh`` will install ``packer`` and ``packer-builder-arm``. If
``git`` isn't installed, it will assume that it should install dependencies. It 
will attempt to install these dependencies with ``apt``.

The script will clone the ``packer-builder-arm`` into the ``build`` directory.

The dependencies required to build images with ``packer`` are:

- git
- unzip
- xz-utils
- qemu-user-static
- e2fsprogs
- dosfstools
- libarchive-tools

Go will also need to be installed; there is a script provided in the :doc:`tools`
directory.

If the ``FORCE_DEPENDENCY_INSTALL`` environment variable is set to ``"yes"``, it
will attempt to install the dependencies even if ``git`` is installed.

``build-image.sh``
^^^^^^^^^^^^^^^^^^

``build-image.sh`` will attempt to build a packer image. It requires that
``packer`` and ``packer-builder-arm`` have been installed, e.g. via
``install-packer.sh``. It will use a board file (see below) to build this
image. If the board file contains both a remote file URL and a local file path,
it will attempt to download the remote file to the local path to cache it. If
the environment variable ``SKIP_LOCAL_CACHE=yes``, it will skip doing this. It
will also skip caching if the local file exists, though it will print a command
to remove the file to force redownloading.

Board files
------------

A board file is a JSON [#]_ file describing the image that packer should build.
There are a lot of examples in the packer-builder-arm boards_ directory.

.. [#] Hashicorp would like you to use their HCL, but I haven't switched
   over yet.

``ubuntu-board-gen``
--------------------

A Go program is provided to generate an Ubuntu-based Packer board file from a
YAML file description. It is a single-minded tool to solve an exact problem;
for more control, or to handle edge case, the board JSON file may be
handwritten or another generator written.

The YAML board specification has the following format:

.. yaml ::

    boards:
      - version: 22.04.2
        size: 32G
        name: cm4-cluster-ubuntu-22.04.2.img
        scripts:
          - scripts/install-base.sh

It will set up a board file pointing to the preinstalled Ubuntu server image.
The size parameter should be one of "4G", "8G", "16G", "32G", or "64G". The
example above is only using a shell provisioner, but there are many different
provisioners available. A longer example would look like

.. yaml ::

    boards:
      - version: 22.04.2
        size: 4G
        name: cm4-cluster-ubuntu-22.04.2.img
        local-scripts:
          - scripts/generate-auth-keys
          - scripts/template-that-one-file
        files:
          - source: build/privkey.pem 
            destination: /etc/myservice/privkey.pem
          - source: build/cert.pem 
            destination: /etc/myservice/cert.pem
          - source: build/that-one-file
            destination: /etc/that-one-file
        scripts:
          - scripts/set-auth-key-permissions.sh
          - scripts/install-base-platform.sh      

The order of precedence for provisioners is local scripts (which might be used
to generate files), files, and then scripts.

Any generated files should be placed in ``build/``, and any scripts should be
placed in ``scripts/`` for consistency.

.. _boards: https://github.com/mkaczanowski/packer-builder-arm/tree/master/boards