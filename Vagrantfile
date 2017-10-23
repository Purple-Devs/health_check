# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = "ubuntu/xenial64"

  # set auto_update to false, if you do NOT want to check the correct 
  # additions version when booting this machine
  config.vbguest.auto_update = false
    
  # do NOT download the iso file from a webserver
  config.vbguest.no_remote = true

  # provision with a shell script.
  config.vm.provision "shell", path: "./test/provision_vagrant"

end
