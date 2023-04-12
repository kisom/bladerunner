packer
======

`packer <https://www.packer.io/>`_ is used to generate the base images for the cluster.

Build scripts
-------------

There are a few scripts that are used in building a packer image. In general,
the workflow looks like:

1. ``install-packer.sh``
2. ``build-image.sh``

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

Board files
------------

