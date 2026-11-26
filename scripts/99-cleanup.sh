#!/usr/bin/env bash
apt-get -y autoremove
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/*
journalctl --vacuum-time=1s
cat /dev/null > /home/vagrant/.bash_history
dd if=/dev/zero of=/EMPTY bs=1M || true
rm -f /EMPTY
sync