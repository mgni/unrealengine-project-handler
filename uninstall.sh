#!/bin/bash

#-------- Configuration Section Start -----------

#Choose only 1 installation mode (user=user only, system=root)
MODE="user"
#MODE="system"

#Set true to install service menu file for File Manager like Dolphin,... (currently Dolphin only supported)
SERVICE_MENU="true"
#SERVICE_MENU="false"
SERVICE_MENU_FILE="unreal-engine-service-menu-dolphin.desktop"

RES_DIR="$PWD/res"
ICON_DIR="$RES_DIR/icon"
ENGINE="$PWD/Engine/Binaries/Linux/UnrealEditor"
ENGINE_FLAGS="-nohighdpi"

#-------- Configuration Section End -----------


#---user mode----
if [ $MODE == "user" ]; then
    echo The MODE is user
    SHARE_DIR="$HOME/.local/share"
    SHELL_DIR="$HOME/.local/bin"
else
#----system----
    SHARE_DIR="/usr/share"
    SHELL_DIR="/usr/local/bin"
fi

if [[ ! -d $RES_DIR ]]; then
    echo 'Error: res Folder Not Found!'
    exit
fi

if [[ ! -f $ENGINE ]]; then
    echo 'Error: Engine Not Found!'
    exit
fi

if [ $MODE == "system" ]; then
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo 'Not running as root! Try run with sudo'
        exit
    fi
fi

echo -e "\nProceeding ..... \n"

rm "$SHARE_DIR/applications/unreal-engine.desktop"
rm "$SHARE_DIR/icons/hicolor/scalable/apps/unreal-engine.svg"
rm "$SHELL_DIR/unrealengine"

for x in 36 48 64 72 96 128 256 512
do
    if [ $MODE == "user" ]; then
        xdg-icon-resource uninstall --novendor --mode user --size $x unreal-engine
        xdg-icon-resource uninstall --novendor --mode user --context mimetypes --size $x unrealengine-project
    else
        xdg-icon-resource uninstall --novendor --mode system --size $x unreal-engine
        xdg-icon-resource uninstall --novendor --mode system --context mimetypes --size $x unrealengine-project
    fi
done

gtk-update-icon-cache "$SHARE_DIR/icons/hicolor"

if [ $MODE == "user" ]; then
    xdg-mime uninstall --mode user "$RES_DIR/unreal-engine-project.xml"
else
    xdg-mime uninstall --mode system "$RES_DIR/unreal-engine-project.xml"
fi

update-mime-database "$SHARE_DIR/mime"
update-desktop-database "$SHARE_DIR/applications"

rm "$SHARE_DIR/kio/servicemenus/$SERVICE_MENU_FILE"

echo 'Uninstall done!'
