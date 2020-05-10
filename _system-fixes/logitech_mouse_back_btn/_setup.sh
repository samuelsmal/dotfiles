#! /bin/bash

##
# Mouse back button
#

# Got it from here
# https://web.archive.org/web/20160604141354/http://forums.logitech.com/t5/Mice-and-Pointing-Devices/Guide-for-setup-Performance-MX-mouse-on-Linux-with-KDE/td-p/517167
sudo dnf install -y xbindkeys

ln -s $PWD/xbindkeysrc $HOME/.xbindkeysrc
