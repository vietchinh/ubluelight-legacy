#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
chmod +x /usr/etc/distrobox-fedora-kde/initialize_distrobox_fedora_kde.sh

cat > /usr/lib/systemd/user/initialize-distrobox-fedora-kde.service << EOF
[Unit]
Description=Autostart kde plasma
ConditionPathExists=/run/ostree-booted
ConditionFileIsExecutable=/etc/distrobox-fedora-kde/initialize_distrobox_fedora_kde.sh

[Service]
Type=oneshot
StandardOutput=journal+console
RemainAfterExit=no
ExecStart=/etc/distrobox-fedora-kde/initialize_distrobox_fedora_kde.sh
EOF

cat > /usr/lib/systemd/user/fedora-kde-plasma-autostart.service << EOF
[Unit]
Description=Autostart kde plasma
ConditionPathExists=/run/ostree-booted

[Service]
Type=simple
ExecStart=/usr/local/bin/distrobox-enter -- /usr/libexec/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland
EOF