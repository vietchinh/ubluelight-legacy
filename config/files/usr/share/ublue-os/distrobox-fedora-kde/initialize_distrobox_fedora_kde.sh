#!/usr/bin/bash

distrobox assemble create --file /usr/etc/distrobox-fedora-kde/fedora-kde.ini

sudo mkdir -p /etc/profile.d/
echo "chown -f -R $USER:$USER /tmp/.X11-unix" | sudo tee -a /etc/profile.d/fix_tmp.sh

#distrobox-export --bin /var/lib/flatpak/ --export-path /var/lib/flatpak/

systemctl --user enable --now fedora-kde-plasma-autostart.service
systemctl disable initialize-distrobox-fedora-kde.service