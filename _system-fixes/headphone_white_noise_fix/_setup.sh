#! /bin/bash

# this is a fix for the stupid white noise using my dell xps laptop
# I got the answer from https://unix.stackexchange.com/questions/336790/how-to-disable-white-noise-with-headphones-in-dell-xps

# remove the shitty white noise while connecting headphones
sudo dnf install acpid
sudo systemctl enable acpid.service

sudo mv ./headphone-plug /etc/acpi/events
sudo mv ./cancel-white-noise.sh /etc/acpi/actions

sudo systemctl restart acpid.service
