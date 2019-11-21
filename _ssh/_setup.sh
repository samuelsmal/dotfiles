#! /bin/bash

TARGET_DIR=$HOME/.config/systemd/user

mkdir -p $TARGET_DIR

cp ./_ssh/ssh-agent.service $TARGET_DIR

echo "Enabling ssh-agent on startup with systemd service"
systemctl --user enable ssh-agent --now

echo "Ensuring ssh-config is setup correctly..."
if [ ! -f ~/.ssh/config ] || ! cat ~/.ssh/config | grep AddKeysToAgent | grep yes > /dev/null; then
  echo "Adding 'AddKeysToAgent yes' to '~/.ssh/config'"
  echo "AddKeysToAgent  yes" >> ~/.ssh/config
else
  echo "ssh config already configured"
fi

if [ ! -f ~/.ssh/config ] || ! cat ~/.ssh/config | grep "CVE-2016-0777" | grep yes > /dev/null; then
  echo "Adding OpenSSH patch to '~/.ssh/config'"
  echo "# Patching OpenSSH bugs CVE-2016-0777 and CVE-2016-0778" >> ~/.ssh.config
  echo "UseRoaming no" >> ~/.ssh.config
else
  echo "ssh already patched"
fi
echo "Ensuring ssh-config is setup correctly... done"
