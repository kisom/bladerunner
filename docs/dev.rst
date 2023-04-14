Development
===========

The cluster isn't going to arrive until at least September. In the
meantime, there are a few phases of development. This is a rough
outline of how I think development will progress. The development
stages will move forward based on when hardware arrives as well as
when certain acceptance criteria are met.

Hardware states
---------------

Key:

- Pi 4/X: Pi 4 with X GB of memory
- CM4 X: Pi CM4 with X GB of memory (has eMMC, wifi, and bluetooth)
- CM4 XL: Pi CM4 with X GB of memory, lite version (no eMMC, wifi, or
  bluetooth)
- D35: Zymbit `D35 Secure Edge Node <https://store.zymbit.com/products/secure-compute-node-d35>`_

+=======+==========+
| Stage | Hardware |
+=======+==========+
| image validation | Pi 3B+, CM4 8L |
| pxeboot validation | Pi 4/8, CM4 8L |


Current stage: 0

Stage 0: basic image validation
-------------------------------

Status: basic validation complete.

This stage is basic validation that the :doc:`packer` process produces
valid images. The goal is to get to a place where, with wired
connectivity, the serial console isn't needed.

This is being done on a CM4 8 at the moment with a carrier board.

Goals
^^^^^

- Ensure :doc:`packer` produces valid images.
- Ensure that images can be flash and installed without requiring
  serial console intervention.

Stage: PXEboot
--------------

The focus here will be on developing a PXE image and figuring out how
to get the Pi to boot that. This is mostly to determine whether or not
this approach will work.

Goals
^^^^^

- Determine if PXE boot is a valid approach.
- Automated build of a PXE image that can perform node
  :doc:`node-provisioning`.

Stage: Automated TPM provisioning
---------------------------------

Here, the goal is to have each node automatically provision and
register its TPM on first boot.

Goals
^^^^^

- Build out a TPM provisioning service.
- Package a TPM provisioner into the boot image.


Stage: 5-node cluster
-----------------------

The next stage is to build out a cluster of 5 Raspberry Pi 4's to
develop basic node bring up and ansible configuration. This will be
built on an UCTRONICS `U6260
<https://www.uctronics.com/uctronics-upgraded-complete-enclosure-for-raspberry-pi-cluster.html>`_
cabinet.

Goals
^^^^^

The 5-node cluster will focus on bringing up nodes automatically.

Stage: 6-node cluster
-----------------------

This stage will add a Zymbit D35 secure edge node in as the secure
root of trust for the cluster - an HSM and identity management system.
