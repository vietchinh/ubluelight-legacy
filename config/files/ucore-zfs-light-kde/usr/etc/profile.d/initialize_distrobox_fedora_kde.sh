#!/usr/bin/bash

distrobox assemble create --file /usr/etc/distrobox-fedora-kde/fedora-kde.ini

#distrobox enter fedora-kde --
#
#sudo ln -s /run/host/run/systemd/system /run/systemd
#sudo mkdir /run/dbus
#sudo ln -s /run/host/run/dbus/system_bus_socket /run/dbus/
#
#sudo dnf install @KDE flatpak -y

rpm-ostree install sddm sddm-breeze sddm-kcm

#sudo mkdir -p /etc/profile.d/
#echo "chown -f -R $USER:$USER /tmp/.X11-unix" | sudo tee -a /etc/profile.d/fix_tmp.sh

#distrobox-export --bin /var/lib/flatpak/ --export-path /var/lib/flatpak/

sudo systemctl enable --now sddm.service

rm -f "/usr/etc/profile.d/initialize_distrobox_fedora_kde.sh"