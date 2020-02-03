#! /bin/bash

install_scrcpy() {
  git clone https://github.com/Genymobile/scrcpy $HOME/proj/scrcpy
  cd $HOME/proj/scrcpy
  meson x --buildtype release --strip -Db_lto=true
  ninja -Cx
  sudo ninja -Cx install
  cd -
}

setup_latex() {
  sudo dnf install latexmk texlive-pdfpages texlive-todo texlive-biblatex biber texlive-scheme-minimal
}

setup_skype() {
  sudo flatpak install -y --from https://flathub.org/repo/appstream/com.skype.Client.flatpakref
}

setup_toggl() {
  sudo flatpak install -y --from https://flathub.org/repo/appstream/com.toggl.TogglDesktop.flatpakref
}

setup_docker() {
  sudo dnf install docker
  echo "adding user to docker group, not super secure but I fucking hate to type my pw all the time"
  sudo groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker
  newgrp docker
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

  # meld is used as a git-mergetool
  sudo dnf install meld

  setup_docker
  setup_latex
  setup_skype
  setup_toggl
}
