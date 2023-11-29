#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
mkdir -p /usr/etc/distrobox-fedora-kde/

cat > /usr/etc/distrobox-fedora-kde/initialize_distrobox_fedora_kde.sh << EOF
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
ln -s /usr/bin/distrobox-host-exec /usr/local/bin/flatpak

sudo dnf groupinstall KDE -y
sudo dnf install flatpak -y

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

exit

sudo mkdir -p /etc/profile.d/
sudo echo "chown -f -R $USER:$USER /tmp/.X11-unix" >> /etc/profile.d/fix_tmp.sh

distrobox-export --bin /var/lib/flatpak/ --export-path /var/lib/flatpak/

systemctl --user enable --now fedora-kde-plasma-autostart.service
systemctl --user disable initialize-distrobox-fedora-kde.service
EOF

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