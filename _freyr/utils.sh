#! /bin/bash

check_and_remove_file () {
  [[ -f $1 ]] && rm -f $1
}

check_and_remove_dir () {
  [[ -d $1 ]] && rm -f $1
}
