JASMIN Analysis Platform : Vagrant VM configuration
===================================================

This repository will create a VM with the JASMIN Analysis Platform installed.  It requires VirtaulBox_ and Vagrant_.

The process is that a vanilla VM image is downloaded from the internet and VirtualBox is configured to run the image.  At boot time Puppet_ is automatically invoked to configure the yum repositories needed to install the ``jasmin-sci-vm`` package.  The "Development tools" yum group is installed and finally ``jasmin-sci-vm`` is installed.

As currently written it will only work within the RAL network.  Future work will enable the VM to be built from our public RPM repository.

Getting Started
---------------

1. Install VirtualBox_
2. Install Vagrant_.  You will need a recent version of vagrant.  Tested as working on v1.2.2
3. Run "vagrant up".  On first execution this will take a long time as it will download a base VM image from the internet.
4. visit the VM with "vagrant ssh"


TODO
----

1. Better documentation :-)
2. Generalised to public RPM repositories


.. _Vagrant: http://docs.vagrandup.com
.. _Virtualbox: http://www.virtualbox.org
.. _Puppet: http://puppetlabs.com
