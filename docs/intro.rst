Introduction
============

I'm working on building a cluster of Raspberry Pi CM4 compute blades. I plan on
using the cluster to learn a bunch of stuff, but I need to be able to provision
the blades automatically. This repo is my work in that area.

There are some assumptions made:

1. All the systems involved are Debian-ish systems, particularly Ubuntu. The
   build system here will assume this. It may work on non-Ubuntu apt-based
   systems. For non-Debian systems, I've also been working on including
   container builds that may work.

There are three types of systems:

- ``dev`` indicates DEV compute blades.
- ``tpm`` indicates TPM compute blades.
- ``gw`` indicates the gateway system, which may perform other functions.

The `computeblade docs <https://docs.computeblade.com/>`_ has a description of
the different blade types.

Below is a diagram of the planned system.

.. graphviz ::

    digraph cluster {
        subgraph {
            dev01;
            dev02;
            dev03;
            dev04;
            dev05;

            tpm01;
            tpm02;
            tpm03;
            tpm04;
            tpm05;
        }

        "poe-switch" -> dev01 [dir=both];
        "poe-switch" -> dev02 [dir=both];
        "poe-switch" -> dev03 [dir=both];
        "poe-switch" -> dev04 [dir=both];
        "poe-switch" -> dev05 [dir=both];

        "poe-switch" -> tpm01 [dir=both];
        "poe-switch" -> tpm02 [dir=both];
        "poe-switch" -> tpm03 [dir=both];
        "poe-switch" -> tpm04 [dir=both];
        "poe-switch" -> tpm05 [dir=both];

        "poe-switch" -> gw [dir=both];
        publicnet    -> gw [dir=both];
    }


The hardware isn't slated to arrive until September at the earliest.

Hardware
--------

Blades:

