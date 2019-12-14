#! /bin/bash

install_nordvpn () {
  echo "Installing nordvpn ..."
  nordvpn_version="1.0.0-1"
  sudo wget -qnc "https://repo.nordvpn.com/yum/nordvpn/centos/noarch/Packages/n/nordvpn-release-$nordvpn_version.noarch.rpm" -P /tmp/
  sudo dnf install -y /tmp/nordvpn-release-$nordvpn_version.noarch.rpm
  sudo dnf install -y nordvpn
  echo "Installing nordvpn ... done"
}

migration_step_2() {
  install_nordvpn
}
