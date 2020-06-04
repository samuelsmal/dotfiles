#! /bin/bash

BRIDGE_VERSION="1.2.7-1"

wget https://protonmail.com/download/protonmail-bridge-$BRIDGE_VERSION.x86_64.rpm -P ~/Downloads
wget https://protonmail.com/download/bridge_pubkey.gpg -P ~/Downloads
sudo rpm --import "$HOME/Downloads/bridge_pubkey.gpg"

SUCCESSFULL_RETURN_STR="$HOME/Downloads/protonmail-bridge-$BRIDGE_VERSION.x86_64.rpm: digests signatures OK"

if [[ `rpm --checksig "$HOME/Downloads/protonmail-bridge-$BRIDGE_VERSION.x86_64.rpm"` == "$SUCCESSFULL_RETURN_STR" ]]; then
  #sudo dnf install -y ~/Downloads/protonmail-bridge-$BRIDGE_VERSION.x86_64.rpm
  rm $HOME/Downloads/protonmail-bridge-$BRIDGE_VERSION.x86_64.rpm
  rm $HOME/Downloads/bridge_pubkey.gpg
  echo "protonmail bridge successfully installed, now configure it, go there: https://protonmail.com/bridge/thunderbird#1"
else
  echo "WARNING: signatures don't match! aborting installation of protonmail bridge"
fi
