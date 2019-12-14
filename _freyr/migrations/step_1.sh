#! /bin/bash

install_flatpaks () {
  echo "Installing flatpaks..."
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install -y flathub discord
  flatpak install -y flathub com.spotify.Client
  flatpak install -y flathub org.signal.Signal
  flatpak install -y flathub org.telegram.desktop
  flatpak install -y flathub com.mattermost.Desktop
  echo "Installing flatpaks ... done"
}

migration_step_1() {
  sudo dnf remove snapd tmuxinator
  install_flatpaks
}

