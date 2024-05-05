#!/bin/bash

SHARE_DIR="/usr/share"
SHELL_DIR="/usr/local/bin"
RES_DIR="$PWD/res"
ICON_DIR="$RES_DIR/icon"
ENGINE="$PWD/Engine/Binaries/Linux/UnrealEditor"
ENGINE_FLAGS="-nohighdpi"

echo -e "\nProceeding ..... \n"

rm "$SHARE_DIR/applications/unreal-engine.desktop"
rm "$SHARE_DIR/icons/hicolor/scalable/apps/unreal-engine.svg"
rm "$SHELL_DIR/unrealengine"

for x in 36 48 64 72 96 128 256 512
do
    xdg-icon-resource uninstall --size $x unreal-engine
    xdg-icon-resource uninstall --context mimetypes --size $x unrealengine-project
done

gtk-update-icon-cache "$SHARE_DIR/icons/hicolor"
xdg-mime uninstall --mode system "$RES_DIR/unreal-engine-project.xml"
update-mime-database "$SHARE_DIR/mime"
update-desktop-database "$SHARE_DIR/applications"

echo 'Uninstall done!'
