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
package { 'epel6':
  ensure => installed,
  provider => rpm,
  source => 'http://yumit.esc.rl.ac.uk/raltools/rhel6/RPMS/epel-tier1-6-1.noarch.rpm'
}


# Unless we itemise each development package we have no option but to use
# exec to install this group.
exec { 'yum Group Install':
  require => File['/etc/yum.conf'],
  unless => '/usr/bin/yum grouplist "Development tools" | /bin/grep "^Installed Groups"',
  command => '/usr/bin/yum -y groupinstall "Development tools"'
}
  
#!NOTE: This will only work if your VM host is inside the firewall
yumrepo { 'jasmin':
  baseurl => "http://yumit.jc.rl.ac.uk/yum/rhel6",
  cost => absent,
  descr => "JASMIN RPM repository",
  proxy => "_none_",
  enabled => 1,
  gpgcheck => 1,
  gpgkey => "file:///vagrant/rpm-gpg/JASMIN-RPM-GPG-KEY",
  priority => 10
}

package { 'jasmin-sci-vm':
  require => Yumrepo['jasmin'],
  ensure => installed
}

