#! /bin/bash

echo "Setting system settings (dconf)"

dconf_files=`find _system-settings/ -name "*.dconf"`
echo $dconf_files

for cfg in $dconf_files; do
  # 6 for the '.dconf', 17 for the '_system-settings/' part
  cfg_path_len=$((${#cfg}-6-17))
  cfg_title=${cfg:17:$cfg_path_len}
  cfg_title=${cfg_title//_/\/}
  cfg_title="/$cfg_title/"


  echo "Setting $cfg_title config using $cfg"
  #dconf reset -f $cfg_title
  dconf load $cfg_title < $cfg
done
