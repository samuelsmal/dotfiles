#! /bin/bash

tiddly_desktop_version="0.0.14"
tiddly_desktop_location=$HOME/.local/opt/tiddlydesktop

echo "downloading and extracting tiddlywiki version v$tiddly_desktop_version"

wget -q -O $tiddly_desktop_location/tmp.zip \
  https://github.com/Jermolene/TiddlyDesktop/releases/download/v$tiddly_desktop_version/tiddlydesktop-linux64-v$tiddly_desktop_version.zip && \
  unzip -q -d $tiddly_desktop_location $tiddly_desktop_location/tmp.zip && \
  rm $tiddly_desktop_location/tmp.zip

echo "creating desktop entry"

desktop_file_path=$HOME/.local/share/applications/tiddlydesktop.desktop
if [[ -f "$desktop_file_path" ]]; then
  rm $desktop_file_path
fi

cp `dirname "$0"`/tiddlydesktop.desktop.template $desktop_file_path
sed -i "s/_VERSION_/$tiddly_desktop_version/g" $desktop_file_path

echo "tiddlydesktop is setup"
