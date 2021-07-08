# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  #config.vm.box = "base"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  
  # SHELL
  


#config.vm.boot_timeout = 300




Vagrant.configure("2") do |config|

   config.vm.define "elk" do |elk|

    elk.vm.box = "ubuntu/focal64"
    elk.vm.hostname = "elk"
    elk.vm.provider "virtualbox" do |vb|
        vb.memory = "5120"
		file_to_disk = "disco-elk.vmdk"
		unless File.exist?(file_to_disk)
			vb.customize ["createmedium", "disk", "--filename", "disco-elk.vmdk", "--format", "vmdk", "--size", 5120 * 1]
		end
		vb.customize ["storageattach", :id, "--storagectl", "SCSI", "--port", "2", "--device", "0", "--type", "hdd", "--medium", file_to_disk]

		
    end
    elk.vm.network "private_network", ip: "192.168.11.11", nic_type: "virtio", virtualbox__intnet: "mynetwork"
    elk.vm.network "forwarded_port", guest: 9200, host: 9200 
    elk.vm.network "forwarded_port", guest: 5601, host: 8081 
    elk.vm.provision "shell", path: "provision-elk.sh"
  end


  config.vm.define "wordpress" do |wordpress|

    wordpress.vm.box = "ubuntu/focal64"
	wordpress.vm.hostname = "wordpress"
    wordpress.vm.provider "virtualbox" do |vb|
		vb.memory = "1024"	
		file_to_disk = "disco-wordpress.vmdk"
		unless File.exist?(file_to_disk)
			vb.customize ["createmedium", "disk", "--filename", "disco-wordpress.vmdk", "--format", "vmdk", "--size", 2048 * 1]
		end
		vb.customize ["storageattach", :id, "--storagectl", "SCSI", "--port", "2", "--device", "0", "--type", "hdd", "--medium", file_to_disk]
		
    end  
    wordpress.vm.network "private_network", ip: "192.168.11.10", nic_type: "virtio", virtualbox__intnet: "mynetwork"
	wordpress.vm.network "forwarded_port", guest: 81, host: 8082
    wordpress.vm.network "forwarded_port", guest: 80, host: 8080
    wordpress.vm.network "forwarded_port", guest: 3306, host: 3306 
    wordpress.vm.provision "shell", path: "provision-wordpress.sh"
  end



  
end

