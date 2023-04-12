tools
=====

The ``tools`` directory contains various helper scripts for building systems.

- ``install.sh`` will run all of the scripts in the expected order.

- ``install-dependencies.sh`` installs all of the dependencies required by the
  various parts of the build system.
- ``install-go.sh`` attempts to install Go using godeb_. It requires some of
  the dependencies that would be installed by ``install-dependencies.sh``.
- ``install-bazel.sh`` installs bazelisk_ and buildifier_. It requires Go in
  addition to some of the dependencies that would be installed by
  ``install-depdencies.sh``.

Dependencies
------------

Optional dependencies are marked with a *?*.

+-----------------------------+----------------------+------------------------------------------------+
| Script                      | Dependencies         | Solved by                                      |
+-----------------------------+----------------------+------------------------------------------------+
| ``install-dependencies.sh`` | apt, sudo?           |                                                |
+-----------------------------+----------------------+------------------------------------------------+
| ``install-go.sh``           | curl, sudo, tar      | ``install-dependencies.sh``                    |
+-----------------------------+----------------------+------------------------------------------------+
| ``install-bazel.sh``        | curl, git, go, sudo? | ``install-dependencies.sh``, ``install-go.sh`` |
+-----------------------------+----------------------+------------------------------------------------+

Dockerfile
----------

The Dockerfile sets up an Ubuntu container and runs the install scripts. Its
entrypoint is ``bash``.

.. _bazelisk: https://github.com/bazelbuild/bazelisk
.. _buildifier: https://github.com/bazelbuild/buildtools
.. _godeb: https://github.com/niemeyer/godeb
