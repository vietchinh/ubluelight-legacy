#!/usr/bin/bash

distrobox assemble create --file /usr/etc/distrobox-fedora-kde/fedora-kde.ini

distrobox enter fedora-kde -- sudo ln -s /run/host/run/systemd/system /run/systemd
distrobox enter fedora-kde -- sudo mkdir /run/dbus
distrobox enter fedora-kde -- sudo ln -s /run/host/run/dbus/system_bus_socket /run/dbus/
distrobox enter fedora-kde -- sudo dnf install @KDE flatpak -y

sudo rpm-ostree install sddm sddm-breeze sddm-kcm

echo "chown -f -R $USER:$USER /tmp/.X11-unix" | sudo tee -a /etc/profile.d/fix_tmp.sh

sudo systemctl set-default graphical.target

sudo rm -f "/etc/profile.d/initialize_distrobox_fedora_kde.sh"