#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
CONTAINER_NAME="fedora-kde"

distrobox create --name $CONTAINER_NAME --image registry.fedoraproject.org/fedora:latest
distrobox enter $CONTAINER_NAME

sudo umount /run/systemd/system
sudo rmdir /run/systemd/system
sudo ln -s /run/host/run/systemd/system /run/systemd
sudo ln -s /run/host/run/dbus/system_bus_socket /run/dbus/
ln -s /usr/bin/distrobox-host-exec /usr/local/bin/podman
ln -s /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrep0

sudo dnf groupinstall KDE -y

exit

mkdir -p /usr/etc/profile.d/
echo "chown -f -R $USER:$USER /tmp/.X11-unix" >> /usr/etc/profile.d/fix_tmp.sh

cat > ~/.profile << EOF
if [ -f /usr/libexec/kactivitymanagerd ]; then
  /usr/libexec/kactivitymanagerd & disown
fi
EOF


cat > /usr/lib/systemd/system/fedora-kde-plasma-autostart.service << EOF
[Unit]
Description=Autostart kde plasma
ConditionPathExists=/run/ostree-booted

[Service]
Type=simple
ExecStart=/usr/local/bin/distrobox-enter -- /usr/libexec/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland
EOF