group { "puppet":
  ensure => "present",
}
 
File { owner => 0, group => 0, mode => 0644 }
 
file { '/etc/motd':
  content => "Welcome to the JASMIN Analysis Platform.
                Managed by Puppet.\n"
}

# Install the EPEL6 RPM repository
# This install path is internal to RAL but alternative public URLs exist.
#!TODO: this doesn't set the repository priority.  
#  Either find a way to update this in puppet or switch to a yumrepo declaration
package { 'epel6':
  ensure => installed,
  provider => rpm,
  source => 'http://yumit.esc.rl.ac.uk/raltools/rhel6/RPMS/epel-tier1-6-1.noarch.rpm'
}


#!TODO: this doesn't work yet because yumit.jc is refusing access
#yumrepo { 'jasmin':
#  baseurl => "http://yumit.jc.rl.ac.uk/yum/rhel6",
#  cost => absent,
#  descr => "JASMIN RPM repository",
#  enabled => 1,
#  priority => 10
#}
#
#package { 'jasmin-sci-vm':
#  ensure => installed
#}
