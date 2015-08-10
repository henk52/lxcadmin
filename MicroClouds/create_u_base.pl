#!/usr/bin/perl -w

use strict;


#See also: https://github.com/henk52/knowledgesharing/wiki/LinuxContainer

my  $szContainerName = "u_base";

my $f_szSourcePath = "$ENV{HOME}/MicroClouds";



# Creates the Ubuntu base LXC.
print "III Creating u_base.\n";
#`sudo lxc-create -t download -n u_base -- -d ubuntu -r trusty -a amd64`;
die("!!! command failed.") unless($? == 0);

`sudo lxc-start -n $szContainerName -d `;
die("!!! command failed $?.") unless($? == 0);

  my $szExternalPathToVagrantDir = "/var/lib/lxc/$szContainerName/rootfs/vagrant";
  `sudo mkdir $szExternalPathToVagrantDir`;
  `sudo cp -r $f_szSourcePath/install_u_base $szExternalPathToVagrantDir`;
  `sudo chmod +x $szExternalPathToVagrantDir/install_u_base`;

  print "III Wait for $szContainerName to be running.\n";
  `sudo lxc-wait -n $szContainerName -s 'RUNNING'`;

  print "III running /vagrant/install_u_base.\n";
  `sudo lxc-attach -n $szContainerName -- /vagrant/install_u_base`;

  

# TOD stop the container
# TODO wait for the container to stop.

  print "III shutting down $szContainerName\n";
`sudo lxc-attach -n $szContainerName -- /sbin/shutdown -h now`;

  print "III Waiting for $szContainerName to shutdown.\n";
`sudo lxc-wait -n $szContainerName -s 'STOPPED'`;

print "III Done.\n";
