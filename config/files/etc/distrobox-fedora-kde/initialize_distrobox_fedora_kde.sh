#!/usr/bin/bash

CONTAINER_NAME="fedora-kde"

distrobox create --yes --name $CONTAINER_NAME --image registry.fedoraproject.org/fedora:latest
distrobox enter $CONTAINER_NAME

sudo umount /var/lib/flatpak
sudo umount /run/systemd/system
sudo rmdir /run/systemd/system
sudo ln -s /run/host/run/systemd/system /run/systemd
sudo ln -s /run/host/run/dbus/system_bus_socket /run/dbus/
ln -s /usr/bin/distrobox-host-exec /usr/local/bin/podman

sudo dnf groupinstall KDE -y
sudo dnf install flatpak -y

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

exit

sudo mkdir -p /etc/profile.d/
echo "chown -f -R $USER:$USER /tmp/.X11-unix" | sudo tee -a /etc/profile.d/fix_tmp.sh

distrobox-export --bin /var/lib/flatpak/ --export-path /var/lib/flatpak/

systemctl --user enable --now fedora-kde-plasma-autostart.service
systemctl --user disable initialize-distrobox-fedora-kde.service