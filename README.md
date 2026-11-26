# DevOps Bootcamp Lab



**A Preconfigured Ubuntu Desktop Environment for DevOps Learning and Practice**



[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange?logo=ubuntu)](https://ubuntu.com/)

[![Vagrant](https://img.shields.io/badge/Vagrant-Compatible-1868F2?logo=vagrant)](https://www.vagrantup.com/)

[![VirtualBox](https://img.shields.io/badge/VirtualBox-Compatible-183A61?logo=virtualbox)](https://www.virtualbox.org/)

[![Version](https://img.shields.io/badge/Version-1.0.0-blue)]()



## Overview



DevOps Bootcamp Lab is a preconfigured Ubuntu Desktop virtual machine designed to provide a practical environment for learning and experimenting with DevOps tools and workflows.



The environment is distributed as a Vagrant Box and runs through VirtualBox and Vagrant on a compatible host system.



It includes a collection of development tools, infrastructure automation utilities, container technologies, Kubernetes tools, networking utilities, monitoring software, and database clients.



The primary goal is to reduce initial setup time and provide learners with a common environment for practical exercises.



## Features



### Operating System

\- Ubuntu 22.04 Desktop

\- Automatic login for the default lab user

\- SSH server enabled

\- VirtualBox Guest Utilities



### Programming and Development

\- Python 3 and pip

\- Go

\- Node.js and npm

\- Java and Maven

\- Git

\- Visual Studio Code

\- Vim and Nano



### Containers and DevOps

\- Docker Engine

\- Docker Compose

\- Docker Buildx

\- Podman

\- Ansible

\- Ansible Lint

\- Terraform

\- OpenTofu

\- AWS CLI



### Kubernetes Ecosystem

\- kubectl

\- Helm

\- Kind

\- Minikube

\- K9s



### Networking and Security

\- Wireshark

\- TShark

\- Nmap

\- tcpdump

\- iperf3

\- traceroute

\- MTR

\- Netcat

\- DNS utilities

\- UFW

\- iptables

\- nftables

\- Fail2ban



### Monitoring and System Administration

\- htop

\- btop

\- iotop

\- iftop

\- nload

\- ncdu

\- sysstat

\- strace

\- lsof

\- ShellCheck



### Web Servers and Databases

\- Nginx

\- HAProxy

\- MySQL Client

\- PostgreSQL Client

\- Redis CLI

\- SQLite



### Preloaded Docker Images



The build process attempts to download a selection of commonly used Docker images, including:



\- hello-world

\- nginx

\- httpd

\- Ubuntu

\- Debian

\- Alpine

\- BusyBox

\- Python

\- Node.js

\- MySQL

\- PostgreSQL

\- Redis

\- MongoDB

\- Grafana

\- Prometheus

\- Jenkins



Image availability depends on the success of the image-pulling process during the build.



## Virtual Machine Specifications



| Component | Configuration |

|---|---|

| Operating System | Ubuntu 22.04 Desktop |

| Virtualization | VirtualBox |

| Provisioning | Vagrant |

| CPU | 4 vCPUs |

| RAM | 8 GB |

| Virtual Disk | 70 GB |

| Video Memory | 128 MB |

| Graphics Controller | VMSVGA |

| Clipboard | Bidirectional |

| Network | VirtualBox default networking |



The virtual machine requires sufficient free disk space on the host. The distributed Box is approximately 5.26 GB.



## Host Requirements



Before starting, make sure you have:



\- A 64-bit Windows host system.

\- Oracle VirtualBox installed.

\- HashiCorp Vagrant installed.

\- At least 8 GB of available RAM for the guest, in addition to the host operating system's requirements.

\- Sufficient free disk space for the downloaded Box and virtual machine.

\- Internet access for downloading the Box and any tools or images that are not already available locally.



## Installation



### 1. Download the Vagrant Box



Download the prebuilt Box file:



**Download:** [Download devops-lab.box](https://drive.google.com/file/d/1wExi8TbP-So34wYBbsfxI1GNfNI3aIdk/view?usp=sharing)



Create a local `releases` directory inside the project folder and place the downloaded file there:



```text

devops-bootcamp-lab/

├── releases/

│   └── devops-lab.box

├── Vagrantfile

└── ...

```



### 2. Verify the Box Integrity



The expected SHA256 checksum is:



```text

A77D4098D69969407214F38B55E56E2ECBB47C4B342CEB6D7559E164130E3A40

```



On Windows PowerShell:



```powershell

Get-FileHash .\\releases\\devops-lab.box -Algorithm SHA256

```



Make sure the resulting hash matches the expected checksum.



### 3. Add the Box to Vagrant



Check whether the Box is already registered:



```powershell

vagrant box list

```



If it is not installed, run:



```powershell

vagrant box add --name devops-lab .\\releases\\devops-lab.box

```



### 4. Start the Virtual Machine



From the project root directory:



```powershell

vagrant up --provider=virtualbox

```



The Ubuntu Desktop virtual machine should start in a VirtualBox window.



### 5. Access the Virtual Machine



The desktop session is configured for automatic login.



You can also access the machine through SSH:



```powershell

vagrant ssh

```



## Default Credentials



| Item | Value |

|---|---|

| Username | `vagrant` |

| Password | `vagrant` |

| Hostname | `devops-lab` |

| Sudo | Passwordless sudo enabled |



**Security warning:** These credentials are intended exclusively for a disposable educational lab environment. Do not use them for production systems, expose the VM to untrusted networks, or store sensitive information inside it.



## Basic Vagrant Commands



Run these commands from the directory containing the Vagrantfile.



| Command | Description |

|---|---|

| `vagrant up` | Start the VM |

| `vagrant halt` | Shut down the VM |

| `vagrant reload` | Restart the VM |

| `vagrant ssh` | Connect through SSH |

| `vagrant status` | Check VM status |

| `vagrant suspend` | Suspend the VM |

| `vagrant resume` | Resume a suspended VM |

| `vagrant destroy` | Delete the VM |



**Warning:** `vagrant destroy` deletes the virtual machine. Back up any important work before running it.



## Project Structure



```text

devops-bootcamp-lab/

├── ansible/

├── assets/

├── checksums/

│   └── SHA256SUMS

├── config/

├── docs/

├── labs/

├── packer/

│   ├── http/

│   │   └── preseed.cfg

│   └── ubuntu-devops.pkr.hcl

├── scripts/

│   ├── 01-base.sh

│   ├── 02-devops-tools.sh

│   ├── 03-preload-docker.sh

│   ├── 04-final.sh

│   ├── 99-cleanup.sh

│   └── check-tools.sh

├── .gitignore

├── Vagrantfile

└── README.md

```



The distributed Box and Ubuntu ISO are stored separately from the Git repository because of their file sizes.



## Building the Environment with Packer



The project includes a Packer configuration for creating the Ubuntu-based virtual machine.



Requirements:



\- Packer

\- VirtualBox

\- Ubuntu 22.04 Desktop ISO

\- Required Packer VirtualBox plugin



Initialize the plugin:



```powershell

cd packer

packer init .

```



Validate the configuration:



```powershell

packer fmt -check .

packer validate .

```



Build the virtual machine:



```powershell

packer build ubuntu-devops.pkr.hcl

```



**Important:** The current Packer configuration uses local paths configured for the original development environment. It also uses `skip_export = true`, so the build does not automatically produce a distributable `.box` file. Exporting and packaging the resulting VM requires an additional step.



## Version 1.0.0 — Known Limitations



This is the initial release of the project. The following limitations should be considered:



\- Some package and tool installations are best-effort operations. Individual failures may occur during provisioning.

\- The build process requires internet access to download packages, binaries, and Docker images.

\- Not all Docker images are guaranteed to be available in every build.

\- The environment is preconfigured for educational and laboratory use, not production deployment.

\- Some Packer paths are specific to the original Windows development environment.

\- Full offline installation and operation have not been independently verified.

\- The `ansible`, `assets`, `config`, `docs`, and `labs` directories are reserved for future development where applicable.



## Roadmap



Potential improvements for future releases include:



\- More comprehensive offline provisioning.

\- Additional Ansible playbooks and practical labs.

\- Improved configuration management.

\- Automated installation verification and reporting.

\- More portable Packer configuration.

\- Additional DevOps exercises and documentation.



## Contributing



Suggestions, bug reports, and contributions are welcome.



Please describe the issue clearly and include relevant logs or reproduction steps when reporting a problem.



## License



This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

Third-party components remain subject to their respective licenses.



\---



**DevOps Bootcamp Lab — Version 1.0.0**
