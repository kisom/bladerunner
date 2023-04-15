Networking (Notes)
==================

**Note**: this document is just notes for me to plan for future work, basically
a brain dump. It does not document the current state of the system, only
documentsa an idea for one path forward.

Network layout
--------------
*The specifics here are very much subject to change.*

Right now, I have the network laid out on ``192.168.4.0/24``. The ``.1-.20``
hosts are on DHCP; three IPs are assigned to meta/infra nodes, and the rest are
reserved. Compute nodes are given the hostname ``nodeXX``, where ``XX`` is
their host address. The limitation here is on available network ports: I only
have 24 in this rack. I could add another switch, but I don't have a compelling
reason to take up the space.

+ the compute blades are assigned the host addresses ``.1 - .10``.
+ the RPi4 cluster is assigned the host addresses ``.11 - .14``.
+ the secure services node is assigned the host address ``.252``, hostname ``haven01``.
+ the build server is assigned the host address ``.253``, hostname ``build01``.
+ the cluster controller and router is assigned the host address ``.254``,
  hostname ``controller``.

Infrastructure services
-----------------------

+ I think the controller will have a TFTP/PXE boot server as well as run DHCP and
  DNS. I'll also run a `Tailscale <https://tailscale.com/>`_ 
  `subnet router <https://tailscale.com/kb/1019/subnets/>`_ here.

+ The build server is on the network just as a convenience; it's an Intel NUC
  that will be used as a development and staging system for infrastructure.

+ The haven system will get its own page, but it will own the identity
  management system as well as the secrets vault.