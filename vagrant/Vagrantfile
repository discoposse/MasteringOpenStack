# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :controller do |controller_config|

    # Every Vagrant virtual environment requires 
    # a box to build off of.
    controller_config.vm.box = "precise64"

    controller_config.vm.host_name = "controller"

    controller_config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    controller_config.vm.network :hostonly, "172.16.0.201", :netmask => "255.255.0.0"
    controller_config.vm.network :hostonly, "10.5.5.201"

    # Customise the VM virtual hardware
    controller_config.vm.customize ["modifyvm", :id, "--memory", 2048]
    controller_config.vm.customize ["modifyvm", :id, "--cpus", 1]
    controller_config.vm.customize ["createhd", "--filename", "controller-cinder.vdi", "--size", 20480]
    controller_config.vm.customize ["storageattach", :id, "--storagectl", "SATA Controller","--port", 1, "--device", 0, "--type", "hdd", "--medium", "controller-cinder.vdi"] 
  
  end
  config.vm.provision :shell, :path => "controller-setup.sh"
end
