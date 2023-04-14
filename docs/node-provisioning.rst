Node Provisioning
=================

First boot
----------

What needs to happen when a node first boots up?

- It needs to find the network.
- The TPM must be provisioned.
- Storage should be provisioned.
- Ansible should be run to set up any software.

Questions
---------

1. What should boot look like after the first PXE boot?
   - PXE boot and run ansible each time?
   - Install an image to the eMMC (or SD card), booting from that in
     the future and using the NVMe drive for storage?
   - Install an image to the NVMe drive and boot off that in the
     future?
2. What can we do with the TPM?
   - It needs to be registered on first boot.
3. What should be done in the initramfs vs cloud-init?
4. What sort of clustering software should we use?
   - Some sort of container management?
   - Kubernetes?