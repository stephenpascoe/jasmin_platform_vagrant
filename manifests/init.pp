group { "puppet":
  ensure => "present",
}
 
File { owner => 0, group => 0, mode => 0644 }
 
file { '/etc/motd':
  content => "Welcome to the JASMIN Analysis Platform.
                Managed by Puppet.\n"
}

#file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6':
#  #!TODO: where to get the file from
#}

#!TODO: this could use the EPEL package RPM
# yumrepo {
#   baseurl => "http://repos.gridpp.rl.ac.uk/yum/epel/6/x86_64"
#   cost => "absent"
#   name => "RAL Tier1 RHEL6 epel mirror"
#   enabled => 1
#   gpgcheck => 1
#   gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6"
#   priority => 20
# }

# yumrepo {
#   baseurl => "http://yumit.jc.rl.ac.uk/yum/rhel6"
#   cost => "absent"
#   name => "JASMIN RPM repository"
#   enabled => 1
#   #gpgcheck => 1
#   #gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6"
#   priority => 10
# }
