#!/usr/bin/env bash
set -uo pipefail
usermod -aG docker,wireshark vagrant || true
grep -q '^UseDNS no' /etc/ssh/sshd_config || echo "UseDNS no" >> /etc/ssh/sshd_config
echo "=== موارد ناموفق ==="
cat /root/failed-items.txt