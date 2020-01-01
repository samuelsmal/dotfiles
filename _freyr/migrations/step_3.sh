#! /bin/bash

fix_headphone_white_noise () {
  # this is a fix for the stupid white noise using my dell xps laptop
  # I got the answer from https://unix.stackexchange.com/questions/336790/how-to-disable-white-noise-with-headphones-in-dell-xps
  echo "fixing headphone white noise ..."
  bash $FREYR_DIR/system-fixes/headphone_white_noise_fix/_setup.sh
  echo "fixing headphone white noise ... done"
}

add_autostart_applications () {
  local autostart_dir=$HOME/.config/autostart/
  mkdir -p $autostart_dir
  echo "adding load ssh keys to autostart"
  [[ -e $ssh_desktop ]] && rm $ssh_desktop
  cp $FREYR_DIR/_setup/load-ssh-keys.desktop $autostart_dir
}

migration_step_3() {
  fix_headphone_white_noise
  add_autostart_applications
}
