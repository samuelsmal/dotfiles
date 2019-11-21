#! /bin/bash

echo "Trying to apply WLAN settings"
if [ -f ./wpa_supplicant.conf ]; then
  sudo echo "update_config=1" >> /etc/wpa_supplicant/wpa_supplicant.conf
  sudo cat ./wpa_supplicant.conf >> /etc/wpa_supplicant/wpa_supplicant.conf
else
  echo "Did you adapt the template file? (check both password fields)"
  exit 1
fi
