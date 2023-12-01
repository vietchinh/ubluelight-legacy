#!/usr/bin/bash

distrobox assemble create --file /usr/etc/distrobox-fedora-kde/fedora-kde.ini

distrobox enter fedora-kde -- sudo ln -s /run/host/run/systemd/system /run/systemd
distrobox enter fedora-kde -- sudo mkdir /run/dbus
distrobox enter fedora-kde -- sudo ln -s /run/host/run/dbus/system_bus_socket /run/dbus/
distrobox enter fedora-kde -- sudo dnf install \
                                     @"base-x" \
                                     @"Common NetworkManager Submodules" \
                                     @"Fonts" \
                                     @"Hardware Support" \
                                     bluedevil \
                                     breeze-gtk \
                                     breeze-icon-theme \
                                     cagibi \
                                     colord-kde \
                                     cups-pk-helper \
                                     dolphin \
                                     glibc-all-langpacks \
                                     gnome-keyring-pam \
                                     kcm_systemd \
                                     kde-gtk-config \
                                     kde-partitionmanager \
                                     kde-print-manager \
                                     kde-settings-pulseaudio \
                                     kde-style-breeze \
                                     kdegraphics-thumbnailers \
                                     kdeplasma-addons \
                                     kdialog \
                                     kdnssd \
                                     kf5-akonadi-server \
                                     kf5-akonadi-server-mysql \
                                     kf5-baloo-file \
                                     kf5-kipi-plugins \
                                     khotkeys \
                                     kmenuedit \
                                     konsole5 \
                                     kscreen \
                                     kscreenlocker \
                                     ksshaskpass \
                                     ksysguard \
                                     kwalletmanager5 \
                                     kwebkitpart \
                                     kwin \
                                     NetworkManager-config-connectivity-fedora \
                                     pam-kwallet \
                                     phonon-qt5-backend-gstreamer \
                                     pinentry-qt \
                                     plasma-breeze \
                                     plasma-desktop \
                                     plasma-desktop-doc \
                                     plasma-drkonqi \
                                     plasma-nm \
                                     plasma-nm-l2tp \
                                     plasma-nm-openconnect \
                                     plasma-nm-openswan \
                                     plasma-nm-openvpn \
                                     plasma-nm-pptp \
                                     plasma-nm-vpnc \
                                     plasma-pa \
                                     plasma-user-manager \
                                     plasma-workspace \
                                     plasma-workspace-geolocation \
                                     polkit-kde \
                                     qt5-qtbase-gui \
                                     qt5-qtdeclarative \
                                     sddm \
                                     sddm-breeze \
                                     sddm-kcm \
                                     setroubleshoot \
                                     sni-qt \
                                     xorg-x11-drv-libinput

sudo rpm-ostree install sddm sddm-breeze sddm-kcm

echo "chown -f -R $USER:$USER /tmp/.X11-unix" | sudo tee -a /etc/profile.d/fix_tmp.sh

sudo systemctl enable --now sddm.service

sudo rm -f "/etc/profile.d/initialize_distrobox_fedora_kde.sh"