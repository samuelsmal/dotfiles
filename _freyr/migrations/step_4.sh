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
  install_scrcpy
}
