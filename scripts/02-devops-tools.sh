#!/usr/bin/env bash
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive
FAILED=/root/failed-items.txt
try() { "$@" || echo "FAILED: $*" >> "$FAILED"; }
. /etc/os-release

APT_PKGS="
ca-certificates gnupg lsb-release software-properties-common apt-transport-https
git vim nano tmux htop btop tree jq unzip zip rsync ncdu bash-completion
make gcc g++ shellcheck
python3 python3-pip python3-venv pipx python3-yaml python3-requests python3-boto3
golang-go nodejs npm default-jdk maven
net-tools iproute2 dnsutils iputils-ping traceroute mtr-tiny nmap tcpdump
netcat-openbsd iperf3 whois ufw iptables nftables fail2ban
lsof strace sysstat iotop iftop nload
nginx haproxy apache2-utils certbot
mysql-client postgresql-client redis-tools sqlite3
ansible ansible-lint podman
"
for p in $APT_PKGS; do try apt-get install -y "$p"; done

# Wireshark بدون سؤال
echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections
try apt-get install -y wireshark tshark

# nginx و haproxy موقع بوت بالا نیایند
systemctl disable --now nginx haproxy 2>/dev/null || true

# Docker (مخزن رسمی، و در صورت شکست docker.io اوبونتو)
install -m 0755 -d /etc/apt/keyrings
curl -fsSLo /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" > /etc/apt/sources.list.d/docker.list
if apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
  echo "Docker official OK"
else
  rm -f /etc/apt/sources.list.d/docker.list
  apt-get update
  try apt-get install -y docker.io docker-compose
fi
systemctl enable --now docker

# Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/hashicorp.list
apt-get update || true
try apt-get install -y terraform

# kubectl, Helm, kind, minikube, yq, k9s
KVER=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
try curl -fsSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/${KVER}/bin/linux/amd64/kubectl"
try bash -c "curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
try curl -fsSLo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
try curl -fsSLo /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
try curl -fsSLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
try bash -c "curl -fsSL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz | tar -xz -C /usr/local/bin k9s"
chmod +x /usr/local/bin/{kubectl,kind,minikube,yq} 2>/dev/null || true

# OpenTofu, AWS CLI, VS Code
try snap install opentofu --classic
cd /tmp
try curl -fsSLo awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
try unzip -qo awscliv2.zip
try ./aws/install --update
try curl -fsSLo /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
try apt-get install -y /tmp/vscode.deb

# Ansible collections
try ansible-galaxy collection install community.general community.docker ansible.posix --force