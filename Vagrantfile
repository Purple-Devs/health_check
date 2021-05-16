# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = "ubuntu/focal64"

  # set auto_update to false, if you do NOT want to check the correct 
  # additions version when booting this machine
  config.vbguest.auto_update = false
    
  # do NOT download the iso file from a webserver
  config.vbguest.no_remote = true

  # provision with a shell script.
  config.vm.provision "shell", path: "./test/provision_vagrant"

  config.vm.provider "virtualbox" do |v|
    # travis allocates 7.5 GB, but this is sufficient
    v.memory = 2048
    v.cpus = 2
  end

#  if File.file?('.git') && IO.read('.git') =~ %r{\Agitdir: (.+)/.git/worktrees.*}
#    # Handle git worktrees ...
#    path = $1
#    config.vm.synced_folder path, path
#  end

end
