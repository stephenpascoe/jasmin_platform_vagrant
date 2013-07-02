group { "puppet":
  ensure => "present",
}
 
File { owner => 0, group => 0, mode => 0644 }

 
file { '/etc/motd':
  content => "Welcome to the JASMIN Analysis Platform.
                Managed by Puppet.\n"
}

# This is an adapted version of the default content with the RAL proxy
# added.
file { '/etc/yum.conf':
  content => "
[main]
cachedir=/var/cache/yum/\$basearch/\$releasever
keepcache=0
debuglevel=2
logfile=/var/log/yum.log
exactarch=1
obsoletes=1
gpgcheck=1
plugins=1
installonly_limit=5
distroverpkg=centos-release

proxy=http://wwwcache.rl.ac.uk:8080
"
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


# Test installing a non-local RPM
package { 'lynx':
  ensure => installed,
  require => File['/etc/yum.conf']
}

# Unless we itemise each development package we have no option but to use
# exec to install this group.
exec { 'yum Group Install':
  require => File['/etc/yum.conf'],
  unless => '/usr/bin/yum grouplist "Development tools" | /bin/grep "^Installed Groups"',
  command => '/usr/bin/yum -y groupinstall "Development tools"'
}
  
#!TODO: this doesn't work yet because yumit.jc is refusing access
#yumrepo { 'jasmin':
#  baseurl => "http://yumit.jc.rl.ac.uk/yum/rhel6",
#  cost => absent,
#  descr => "JASMIN RPM repository",
#  enabled => 1,
#  priority => 10
#}

#package { 'jasmin-sci-vm':
#  ensure => installed
#}
