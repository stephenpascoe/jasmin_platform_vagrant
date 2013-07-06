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

# Unless we itemise each development package we have no option but to use
# exec to install this group.
exec { 'yum Group Install':
  require => File['/etc/yum.conf'],
  unless => '/usr/bin/yum grouplist "Development tools" | /bin/grep "^Installed Groups"',
  command => '/usr/bin/yum -y groupinstall "Development tools"'
}

yumrepo { 'epel':
  baseurl => 'http://mirrors.ukfast.co.uk/sites/dl.fedoraproject.org/pub/epel/6/x86_64',
  cost => absent,
  descr => "Public EPEL6 Repository",
  enabled => 1,
  gpgcheck => 1,
  gpgkey => "file:///vagrant/rpm-gpg/RPM-GPG-KEY-EPEL-6",
  require => File['/etc/yum.conf'],
}

yumrepo { 'jasmin_platform':
  baseurl => "http://dist.ceda.ac.uk/yumrepo",
  cost => absent,
  descr => "JASMIN RPM repository",
  proxy => "_none_",
  enabled => 1,
  gpgcheck => 1,
  gpgkey => "file:///vagrant/rpm-gpg/JASMIN-RPM-GPG-KEY",
  priority => 10
}

package { 'jasmin-sci-vm':
  require => [Yumrepo['jasmin_platform'], Yumrepo['epel']],
  ensure => installed
}


# In order to run the ipython notebook demo disable the firewall
service { 'iptables':
  ensure => stopped,
  }
