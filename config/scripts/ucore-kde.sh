#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
DBX_CONTAINER_HOME_PREFIX=/usr/etc/distrobox-fedora-kde

#rpm -ivh /tmp/ublue-os-signing.noarch.rpm
chmod +x "$DBX_CONTAINER_HOME_PREFIX/initialize_distrobox_fedora_kde.sh"

distrobox assemble create --file /usr/etc/distrobox-fedora-kde/fedora-kde.ini

distrobox enter --root fedora-kde

sudo ln -s /run/host/run/systemd/system /run/systemd
sudo mkdir /run/dbus
sudo ln -s /run/host/run/dbus/system_bus_socket /run/dbus/

sudo dnf install @KDE flatpak -your

exit



cat > /usr/lib/systemd/system/initialize-distrobox-fedora-kde.service << EOF
[Unit]
Description=Autostart kde plasma
ConditionPathExists=/run/ostree-booted
ConditionFileIsExecutable=/etc/distrobox-fedora-kde/initialize_distrobox_fedora_kde.sh

[Service]
User=1000
Group=1000
Type=oneshot
StandardOutput=journal+console
RemainAfterExit=no
ExecStart=/etc/distrobox-fedora-kde/initialize_distrobox_fedora_kde.sh

[Install]
WantedBy=multi-user.target
EOF

cat > /usr/lib/systemd/user/fedora-kde-plasma-autostart.service << EOF
[Unit]
Description=Autostart kde plasma
ConditionPathExists=/run/ostree-booted

[Service]
Type=simple
ExecStart=/usr/local/bin/distrobox-enter -- /usr/libexec/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland

[Install]
WantedBy=multi-user.target
EOF