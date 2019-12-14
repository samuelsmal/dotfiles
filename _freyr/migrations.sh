#! /bin/bash

for f in $PWD/_freyr/migrations/*.sh; do source $f; done

migrate (){
  version_lock_file_name="./.version_lock"
  newest_migration=`find $PWD/_freyr/migrations -name "step_*.sh" | sed 's/.*\([0-9]\+\).*/\1/g' | sort -n | tail -1`
  version_lock=0
  if [ -f "$version_lock_file_name" ]; then
    version_lock=$(<"$version_lock_file_name")
  fi
  echo "version_lock: $version_lock"

  for step in $(seq $((version_lock + 1)) $newest_migration); do
    echo "doing step: $step"
    eval "migration_step_$step"

    echo "$step" > "$version_lock_file_name"
  done
}

