# -*- mode: ruby -*-
# vi: set ft=ruby :

name = "mitienda.com"
# Configuracion del Vagrant

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.33.40"
  config.vm.hostname = name

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2048"
  end

  # Copiar archivos de configuración dentro de la VM
  config.vm.provision "file", source: "ops/", destination: "/tmp/"
  # config.vm.provision "file", source: "installers/", destination: "/tmp/"

  # Acelerar el proceso de compartir archivos entre local y VM
  if Vagrant.has_plugin?('vagrant-bindfs')
    config.vm.synced_folder "./", "/mnt/vagrant-base", id: "repo", type: 'nfs',
      perms: "u=rwX:g=rwX:o=rD"
    config.bindfs.bind_folder "/mnt/vagrant-base", "/var/www/",
      owner: 'www-data',
      group: 'vagrant',
      perms: "u=rwX:g=rwX:o=rD"
  else
    config.vm.synced_folder "./", "/var/www/",
      owner: "www-data",
      group: "vagrant",
      perms: "u=rwX:g=rwX:o=rD"
  end

  # Aumentar swap (https://gist.github.com/shovon/9dd8d2d1a556b8bf9c82)
  config.vm.provision :shell, :path => "ops/provision-increase-swap.sh"

  # Instalar servidor web, mysql, php, etc
  config.vm.provision :shell, :path => "ops/provision-vagrant.sh"

  # Instalar Magento
  config.vm.provision :shell, :path => "ops/provision-magento.sh"

end
