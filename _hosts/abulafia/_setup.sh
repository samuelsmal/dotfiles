
# remove the shitty white noise while connecting headphones
sudo dnf install acpid
sudo systemctl enable acpid.service

sudo mv ./audio_white_noise/headphone-plug /etc/acpi/events
sudo mv ./audio_white_noise/cancel-white-noise.sh /etc/acpi/actions

sudo systemctl restart acpid.service
