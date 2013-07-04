JASMIN Analysis Platform : Vagrant VM configuration
===================================================

This repository will create a VM with the JASMIN Analysis Platform installed.  It requires VirtaulBox_ and Vagrant_.

The process is that a vanilla VM image is downloaded from the internet and VirtualBox is configured to run the image.  At boot time Puppet_ is automatically invoked to configure the yum repositories needed to install the ``jasmin-sci-vm`` package.  The "Development tools" yum group is installed and finally ``jasmin-sci-vm`` is installed.

As currently written it will only work within the RAL network.  Future work will enable the VM to be built from our public RPM repository.

Getting Started
---------------

1. Install VirtualBox_
2. Install Vagrant_.  You will need a recent version of vagrant.  Tested as working on v1.2.2
3. Clone this repository.  E.g. ``git clone https://github.com/stephenpascoe/jasmin_platform_vagrant``.
4. From the repository run "vagrant up".  On first execution this will take a long time as it will download a base VM image from the internet.
5. Visit the VM with "vagrant ssh".  You will be logged into the VM as user ``vagrant``.


Using the VM
------------

Details of the VM configuration are in ``Vagrantfile`` and the Puppet manifest ``manifests/init.pp``.  By default the VM forwards port 8888 to your host's local port 8888.  To demonstrate this is working try this recipe::

  $ vigrant ssh
  Last login: Wed Jul  3 15:22:12 2013 from 10.0.2.2
  Welcome to the JASMIN Analysis Platform.
                  Managed by Puppet.
  [vagrant@localhost ~]$ cd /vagrant/ipython/
  [vagrant@localhost ipython]$ ./start.sh 
  [NotebookApp] Using existing profile dir: u'/home/vagrant/.ipython/profile_default'
  [NotebookApp] Serving notebooks from local directory: /vagrant/ipython
  [NotebookApp] The IPython Notebook is running at: http://0.0.0.0:8888/
  [NotebookApp] Use Control-C to stop this server and shut down all kernels.
  [NotebookApp] Using MathJax from CDN: http://cdn.mathjax.org/mathjax/latest/MathJax.js

Now trying visiting http://localhost:8888/


TODO
----

1. Better documentation :-)
2. Generalised to public RPM repositories


.. _Vagrant: http://docs.vagrandup.com
.. _Virtualbox: http://www.virtualbox.org
.. _Puppet: http://puppetlabs.com
