
##############################################################################
# Configuration

# Set the http proxy here so that your VM can access the RPM repositories
$http_proxy = "wwwcache.rl.ac.uk:8080"

# Select your EPEL mirror
$epel_url = 'http://mirrors.ukfast.co.uk/sites/dl.fedoraproject.org/pub/epel/6/x86_64'

##############################################################################

group { "puppet":
  ensure => "present",
}
 
File { owner => 0, group => 0, mode => 0644 }

 
file { '/etc/motd':
  content => "Welcome to the JASMIN Analysis Platform.
                Managed by Puppet.\n"
}


# Unless we itemise each development package we have no option but to use
# exec to install this group.
exec { 'yum Group Install':
  unless => '/usr/bin/yum grouplist "Development tools" | /bin/grep "^Installed Groups"',
  command => '/usr/bin/yum -y groupinstall "Development tools"'
}

yumrepo { 'epel':
  baseurl => $epel_url,
  cost => absent,
  descr => "Public EPEL6 Repository",
  proxy => $http_proxy,
  enabled => 1,
  gpgcheck => 1,
  gpgkey => "file:///vagrant/rpm-gpg/RPM-GPG-KEY-EPEL-6",
}

yumrepo { 'jasmin_platform':
  baseurl => "http://dist.ceda.ac.uk/yumrepo",
  cost => absent,
  descr => "JASMIN RPM repository",
  proxy => $http_proxy,
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
