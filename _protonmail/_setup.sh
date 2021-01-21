#! /bin/bash

# version number + '-1'
BRIDGE_VERSION="1.5.4-1"

wget https://protonmail.com/download/protonmail-bridge-$BRIDGE_VERSION.x86_64.rpm -P ~/Downloads

if ! rpm  -qi gpg-pubkey-\* | grep protonmail > /dev/null 2>&1; then
  echo "key not installed, downloading and installing bridge pubkey"
  wget https://protonmail.com/download/bridge_pubkey.gpg -P ~/Downloads
  sudo rpm --import "$HOME/Downloads/bridge_pubkey.gpg"
  rm $HOME/Downloads/bridge_pubkey.gpg
fi

SUCCESSFULL_RETURN_STR="$HOME/Downloads/protonmail-bridge-$BRIDGE_VERSION.x86_64.rpm: digests signatures OK"

if [[ `rpm --checksig "$HOME/Downloads/protonmail-bridge-$BRIDGE_VERSION.x86_64.rpm"` == "$SUCCESSFULL_RETURN_STR" ]]; then
  sudo dnf install -y ~/Downloads/protonmail-bridge-$BRIDGE_VERSION.x86_64.rpm
  rm $HOME/Downloads/protonmail-bridge-$BRIDGE_VERSION.x86_64.rpm
  echo "protonmail bridge successfully installed, now configure it, go there: https://protonmail.com/bridge/thunderbird#1"
else
  echo "WARNING: signatures don't match! aborting installation of protonmail bridge"
fi
