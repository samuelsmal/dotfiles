#! /bin/bash

# disables downloading of updates
gsettings set org.gnome.software download-updates false

# these are all the background processes of gnome-software
sudo systemctl stop packagekit.service
sudo systemctl disable packagekit.service
sudo systemctl mask packagekit.service
sudo systemctl stop packagekit-offline-update.service
sudo systemctl disable packagekit-offline-update.service
sudo systemctl mask packgekit-offline-update.service
sudo rm -rf /var/cache/PackageKit

# since the above didn't do the trick
sudo dnf remove gnome-software
