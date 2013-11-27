# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos64-x86_64-20131030"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v0.1.0/centos64-x86_64-20131030.box"

  # config.vm.network :private_network, ip: "192.168.33.10"

  # config.vm.provider :virtualbox do |vb|
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  
  config.vm.provision :shell, path: "bootstrap.sh"
end
