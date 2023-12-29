#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.

systemctl mask libvirt

echo "compression-algorithm = lz4" >> /usr/lib/systemd/zram-generator.conf
echo "vm.swappiness = 150" >> /usr/etc/sysctl.conf