#! /bin/bash

install_scrcpy() {
  git clone https://github.com/Genymobile/scrcpy $HOME/proj/scrcpy
  cd $HOME/proj/scrcpy
  meson x --buildtype release --strip -Db_lto=true
  ninja -Cx
  sudo ninja -Cx install
  cd -
}

migration_step_4() {
  # super nice way to connect the android to the pc
  install_scrcpy

  # just eats RAM
  bash $FREYR_DIR/_system-fixes/gnome_software_removal/_setup.sh

  # replacing keepassx with keepassxc
  sudo dnf remove keepassx
  sudo dnf install keepassxc

  # no longer in use
  sudo dnf copr disable -y dgoerger/workstation
  sudo dnf copr remove -y dgoerger/workstation
}
