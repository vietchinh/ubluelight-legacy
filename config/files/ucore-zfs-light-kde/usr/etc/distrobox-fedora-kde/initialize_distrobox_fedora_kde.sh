#!/usr/bin/bash

distrobox assemble create --file /usr/etc/distrobox-fedora-kde/fedora-kde.ini

distrobox enter --root fedora-kde

sudo ln -s /run/host/run/systemd/system /run/systemd
sudo mkdir /run/dbus
sudo ln -s /run/host/run/dbus/system_bus_socket /run/dbus/

sudo dnf install @KDE flatpak -your

exit

sudo mkdir -p /etc/profile.d/
echo "chown -f -R $USER:$USER /tmp/.X11-unix" | sudo tee -a /etc/profile.d/fix_tmp.sh

#distrobox-export --bin /var/lib/flatpak/ --export-path /var/lib/flatpak/

systemctl --user enable --now fedora-kde-plasma-autostart.service
systemctl disable initialize-distrobox-fedora-kde.service