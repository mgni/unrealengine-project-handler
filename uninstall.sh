#!/usr/bin/env bash

#-------- Configuration Section Start -----------

#Set true to install service menu file for File Manager like Dolphin,... (currently Dolphin only supported)
SERVICE_MENU="true"
#SERVICE_MENU="false"
SERVICE_MENU_FILE="unreal-engine-service-menu-dolphin.desktop"

RES_DIR="$PWD/res"
ICON_DIR="$RES_DIR/icon"
ENGINE="$PWD/Engine/Binaries/Linux/UnrealEditor"
ENGINE_FLAGS="-nohighdpi"
#-------- Configuration Section End -----------

SHARE_DIR="$HOME/.local/share"
#SHELL_DIR="$HOME/.local/bin"
[ "${PATH#*$HOME/bin:}" == "$PATH" ] && export PATH="$HOME/bin:$PATH"
SHELL_DIR="$HOME/bin" #for ArchLinux/ZSH

if [[ ! -d $RES_DIR ]]; then
    echo 'Error: res Folder Not Found!'
    exit
fi

if [[ ! -f $ENGINE ]]; then
    echo 'Error: Engine Not Found!'
    exit
fi

echo -e "\nProceeding ..... \n"

rm "$SHARE_DIR/applications/unreal-engine.desktop"
rm "$SHARE_DIR/icons/hicolor/scalable/apps/unreal-engine.svg"
rm "$SHELL_DIR/unrealengine"

for x in 36 48 64 72 96 128 256 512
do
    xdg-icon-resource uninstall --novendor --mode user --size $x unreal-engine
    xdg-icon-resource uninstall --novendor --mode user --context mimetypes --size $x unrealengine-project
done

gtk-update-icon-cache "$SHARE_DIR/icons/hicolor"
xdg-mime uninstall --mode user "$RES_DIR/unreal-engine-project.xml"

update-mime-database "$SHARE_DIR/mime"
update-desktop-database "$SHARE_DIR/applications"

rm "$SHARE_DIR/kio/servicemenus/$SERVICE_MENU_FILE"

echo 'Uninstallation done!'
