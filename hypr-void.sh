#!/bin/sh

# Created By: Javier Pacheco - javier@jpacheco.xyz
# Created On: 08/02/24
# Project: Script that install hyprland in voidlinux

doas xbps-install dbus seatd polkit elogind mesa-dri kitty

cd $HOME
[ -d $HOME/.local/src/ ] && echo "~/.local/src/ folder exits in the system." || mkdir -p $HOME/.local/src/
cd $HOME/.local/src
git clone https://github.com/void-linux/void-packages --depth 1

git clone https://github.com/Makrennel/hyprland-void --depth 1

cd void-packages
./xbps-src binary-bootstrap

cd ../hyprland-void
cat common/shlibs >> ../void-packages/common/shlibs
cp -r srcpkgs/* ../void-packages/srcpkgs

cd ../void-packages
./xbps-src pkg hyprland
./xbps-src pkg xdg-desktop-portal-hyprland
./xbps-src pkg hyprland-protocols
doas xbps-install -R hostdir/binpkgs hyprland
doas xbps-install -R hostdir/binpkgs hyprland-protocols
doas xbps-install -R hostdir/binpkgs xdg-desktop-portal-hyprland

doas ln -s /etc/sv/dbus /var/service
doas ln -s /etc/sv/polkitd /var/service
doas ln -s /etc/sv/seatd /var/service

doas usermod -aG _seatd $USER

rm -rf ./local/src/void-packages
rm -rf ./local/src/hyprland-void
echo "Folders was removed from this device."
