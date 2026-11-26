
packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "ubuntu" {
  vm_name       = "devops-lab"
  guest_os_type = "Ubuntu_64"

  iso_url      = "file:///D:/vagrantt/iso/ubuntu-22.04-desktop-amd64.iso"
  iso_checksum = "B85286D9855F549ED9895763519F6A295A7698FB9C5C5345811B3EEFADFB6F07"

  cpus                 = 4
  memory               = 8192
  disk_size            = 71680
  gfx_vram_size        = 128
  gfx_controller       = "vmsvga"
  hard_drive_interface = "sata"
  iso_interface        = "sata"
  guest_additions_mode = "disable"
  headless             = false

  output_directory = "D:/vagrantt/build/output-vbox"
  keep_registered  = true
  skip_export      = true

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--boot1", "disk"],
    ["modifyvm", "{{.Name}}", "--boot2", "dvd"],
    ["modifyvm", "{{.Name}}", "--clipboard-mode", "bidirectional"]
  ]

  http_directory = "${path.root}/http"
  boot_wait      = "10s"

  boot_command = [
    "e<wait3s>",
    "<down><down><down><end><wait>",
    " automatic-ubiquity noprompt url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    "<f10>"
  ]

  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  ssh_timeout      = "120m"
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
}

build {
  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | sudo -S -E bash '{{ .Path }}'"

    scripts = [
      "${path.root}/../scripts/01-base.sh",
      "${path.root}/../scripts/02-devops-tools.sh",
      "${path.root}/../scripts/03-preload-docker.sh",
      "${path.root}/../scripts/04-final.sh",
      "${path.root}/../scripts/99-cleanup.sh"
    ]
  }
}
