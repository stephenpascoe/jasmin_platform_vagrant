
##############################################################################
# Configuration

# Set the http proxy here so that your VM can access the RPM repositories
# If you are not behind an HTTP proxy set $http_proxy to "_none_"
$http_proxy = "http://wwwcache.rl.ac.uk:8080"
# $http_proxy = "_none_"

# Select your EPEL mirror
$epel_rpm = 'http://mirrors.ukfast.co.uk/sites/dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'

# Select the CEDA yum repository RPM
$cedarepo_rpm = "http://dist.ceda.ac.uk/yumrepo/RPMS/ceda-yumrepo-0.1-1.ceda.el6.noarch.rpm"


##############################################################################


File { owner => 0, group => 0, mode => 0644 }

 
file { '/etc/motd':
  content => "Welcome to the JASMIN Analysis Platform.
                Managed by Puppet.\n"
}

if $http_proxy != '_none_' {
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

proxy=$http_proxy
"
  }
}
else {
  file { '/etc/yum.conf':
    ensure => present,
  }
}


package { 'epel-release-6-8':
  provider => 'rpm',
  ensure => installed,
  source => "$epel_rpm",
}

package { 'ceda-yumrepo':
  provider => 'rpm',
  ensure => installed,
  source => "$cedarepo_rpm",
}

package { 'jasmin-sci-vm':
  require => [Package['epel-release-6-8'], Package['ceda-yumrepo'], File['/etc/yum.conf']],
  ensure => installed,
}


# Unless we itemise each development package we have no option but to use
# exec to install this group.
#exec { 'yum Group Install':
#  require => [File['/etc/yum.conf'], Package['epel-release-6-8']],
#  unless => '/usr/bin/yum grouplist "Development tools" | /bin/grep "^Installed Groups"',
#  command => '/usr/bin/yum -y groupinstall "Development tools"'
#}



# In order to run the ipython notebook demo disable the firewall
service { 'iptables':
  ensure => stopped,
}

# Remove the initial user from the base box
user { 'veewee':
  ensure => 'absent',
  }
file { '/home/veewee':
  ensure => absent,
  recurse => true,
  }
