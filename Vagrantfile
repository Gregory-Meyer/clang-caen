# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.synced_folder ".", "/vagrant", type:"virtualbox", create:true, automount:true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 12288
    vb.cpus = 6
  end
end
