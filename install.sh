#!/bin/bash

SHARE_DIR="/usr/share"
SHELL_DIR="/usr/local/bin"
RES_DIR="$PWD/res"
ICON_DIR="$RES_DIR/icon"
ENGINE="$PWD/Engine/Binaries/Linux/UnrealEditor"
ENGINE_FLAGS="-nohighdpi"

if [[ ! -d $RES_DIR ]]; then
    echo 'Error: res Folder Not Found!'
    exit
fi

if [[ ! -f $ENGINE ]]; then
    echo 'Error: Engine Not Found!'
    exit
fi

echo -e "\nProceeding ..... \n"
#get engine version number
UE_VERSION=`cat "$ENGINE.version" | python -c "import sys, json; obj=json.load(sys.stdin); print('{}.{}.{}'.format(obj['MajorVersion'],obj['MinorVersion'],obj['PatchVersion']))"`
echo "Engine Version : $UE_VERSION found."


sed -i "s^exe.*^exec \'$ENGINE\' \"\$@\"^g"  "$RES_DIR/unrealengine.sh"
sed -i "s^Name.*^Name=Unreal Engine $UE_VERSION^g"  "$RES_DIR/unreal-engine.desktop"
sed -i "s^Exec.*^Exec=unrealengine \%F $ENGINE_FLAGS^g"  "$RES_DIR/unreal-engine.desktop"


install -Dm755 "$RES_DIR/unreal-engine.desktop" "$SHARE_DIR/applications/unreal-engine.desktop"
install -Dm644 "$ICON_DIR/unreal-engine.svg" "$SHARE_DIR/icons/hicolor/scalable/apps/unreal-engine.svg"
install -Dm755 "$RES_DIR/unrealengine.sh" "$SHELL_DIR/unrealengine"

for x in 36 48 64 72 96 128 256 512
do
    magick -density $x -background none "$ICON_DIR/unreal-engine.svg" "$ICON_DIR/unreal-engine-$x.png"
    xdg-icon-resource install --novendor --noupdate --size $x "$ICON_DIR/unreal-engine-$x.png" unreal-engine

    magick -density $x -background none "$ICON_DIR/x-uproject.svg" "$ICON_DIR/project-$x.png"
    xdg-icon-resource install --novendor --noupdate --context mimetypes --size $x "$ICON_DIR/project-$x.png" unrealengine-project

    rm "$ICON_DIR/unreal-engine-$x.png"
    rm "$ICON_DIR/project-$x.png"
done

gtk-update-icon-cache "$SHARE_DIR/icons/hicolor"
xdg-mime install --mode system "$RES_DIR/unreal-engine-project.xml"
update-mime-database "$SHARE_DIR/mime"
update-desktop-database "$SHARE_DIR/applications"

echo 'Installation done!'

#get engine version number
# cat UnrealEditor.version | python -c "import sys, json; obj=json.load(sys.stdin); print(obj['MajorVersion'],obj['MinorVersion'],obj['PatchVersion'])"

#check if file exist
#[ -f $PWD/Engine/Binaries/Linux/UnrealEditor ] && echo "OKEY" 

#replace text
#engine=$PWD/Engine/; sed 's^Exe.*^Exec='$engine'^'  $PWD/res/unreal-engine.desktop