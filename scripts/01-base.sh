#!/usr/bin/env bash
set -uo pipefail
export DEBIAN_FRONTEND=noninteractive
: > /root/failed-items.txt

systemctl disable --now unattended-upgrades 2>/dev/null || true
apt-get update
apt-get -y upgrade
apt-get install -y build-essential dkms linux-headers-$(uname -r) \
  virtualbox-guest-utils virtualbox-guest-x11 openssh-server curl

# کلید عمومی Vagrant
mkdir -p /home/vagrant/.ssh
curl -fsSLo /home/vagrant/.ssh/authorized_keys \
  https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub \
  || echo "FAILED: vagrant key" >> /root/failed-items.txt
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys

# ورود خودکار
mkdir -p /etc/gdm3
cat > /etc/gdm3/custom.conf <<'EOF'
[daemon]
AutomaticLoginEnable=true
AutomaticLogin=vagrant
EOF

# جلوگیری از قفل و خاموشی صفحه
mkdir -p /etc/dconf/profile /etc/dconf/db/local.d
printf 'user-db:user\nsystem-db:local\n' > /etc/dconf/profile/user
cat > /etc/dconf/db/local.d/01-lab <<'EOF'
[org/gnome/desktop/session]
idle-delay=uint32 0
[org/gnome/desktop/screensaver]
lock-enabled=false
EOF
dconf update

systemctl enable ssh