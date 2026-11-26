Vagrant.configure("2") do |config|
  config.vm.box = "devops-lab"
  config.vm.box_url = "file://#{File.expand_path('releases/devops-lab.box', __dir__)}"
  config.vm.box_check_update = false
  config.vm.hostname = "devops-lab"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "devops-lab-vagrant"
    vb.gui = true
    vb.cpus = 4
    vb.memory = 8192

    vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
  end
end