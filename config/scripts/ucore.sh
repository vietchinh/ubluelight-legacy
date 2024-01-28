#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
cat > /usr/lib/systemd/system/rpm-ostreed-upgrade-reboot.service << EOF
# workaround for missing reboot policy
# https://github.com/coreos/rpm-ostree/issues/2843
[Unit]
Description=rpm-ostree upgrade and reboot
ConditionPathExists=/run/ostree-booted

[Service]
Type=simple
ExecStart=/usr/bin/rpm-ostree upgrade --reboot
#StandardOutput=null
EOF

cat > /usr/lib/systemd/system/rpm-ostreed-upgrade-reboot.timer << EOF
[Unit]
Description=rpm-ostree upgrade and reboot trigger on every first monday of the month
ConditionPathExists=/run/ostree-booted

[Timer]
OnCalendar=Mon *-*-1..7 03:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

rpm -ivh /tmp/ublue-os-signing.noarch.rpm

echo "compression-algorithm = zstd" >> /usr/lib/systemd/zram-generator.conf