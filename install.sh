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
chmod +x "$ENGINE"
#get engine version number
UE_VERSION=`cat "$ENGINE.version" | python -c "import sys, json; obj=json.load(sys.stdin); print('{}.{}.{}'.format(obj['MajorVersion'],obj['MinorVersion'],obj['PatchVersion']))"`
echo "Engine Version : $UE_VERSION found."
echo "Setting as default Editor."


sed -i "s^exe.*^exec \'$ENGINE\' \"\$@\"^g"  "$RES_DIR/unrealengine.sh"
sed -i "s^Name.*^Name=Unreal Engine $UE_VERSION^g"  "$RES_DIR/unreal-engine.desktop"
sed -i "s^Exec.*^Exec=$SHELL_DIR/unrealengine \%F $ENGINE_FLAGS^g"  "$RES_DIR/unreal-engine.desktop"


install -Dm755 "$RES_DIR/unreal-engine.desktop" "$SHARE_DIR/applications/unreal-engine.desktop"
install -Dm644 "$ICON_DIR/unreal-engine.svg" "$SHARE_DIR/icons/hicolor/scalable/apps/unreal-engine.svg"
install -Dm755 "$RES_DIR/unrealengine.sh" "$SHELL_DIR/unrealengine"

for x in 36 48 64 72 96 128 256 512
do
	magick -density $x -background none "$ICON_DIR/unreal-engine.svg" "$ICON_DIR/unreal-engine-$x.png"
	xdg-icon-resource install --novendor --noupdate --mode user --size $x "$ICON_DIR/unreal-engine-$x.png" unreal-engine
	xdg-icon-resource install --novendor --noupdate --mode user --size $x "$ICON_DIR/unreal-engine-$x.png" unreal-engine
	magick -density $x -background none "$ICON_DIR/x-uproject.svg" "$ICON_DIR/project-$x.png"
	xdg-icon-resource install --novendor --noupdate --mode user --context mimetypes --size $x "$ICON_DIR/project-$x.png" unrealengine-project
	xdg-icon-resource install --novendor --noupdate --mode user --context mimetypes --size $x "$ICON_DIR/project-$x.png" unrealengine-project

    rm "$ICON_DIR/unreal-engine-$x.png"
    rm "$ICON_DIR/project-$x.png"
done

gtk-update-icon-cache "$SHARE_DIR/icons/hicolor"
xdg-mime install --mode user "$RES_DIR/unreal-engine-project.xml"
update-mime-database "$SHARE_DIR/mime"
update-desktop-database "$SHARE_DIR/applications"

echo Mime installation done.
echo
echo Preparing to install Service Menu File for file manager ...


create_service_menu_for_dolphin ()
{
    # not working in 5.6
    #local projectGenerator="$PWD/Engine/Build/BatchFiles/Linux/GenerateProjectFiles.sh"
    
    # 5.6
    local projectGenerator="$PWD/Engine/Build/BatchFiles/Linux/GenerateProjectFiles.sh"

    if [[ -f /usr/bin/dolphin ]]; then
        cat << EOF > "$RES_DIR/$SERVICE_MENU_FILE"
[Desktop Entry]
Type=Service
MimeType=application/x-uproject;
X-KDE-Submenu=Unreal Engine
#rm -r Binaries Intermediate Saved
#rm -r Binaries Intermediate Saved DerivedDataCache
Actions=CleanCachesFolder_BIS;CleanCachesFolder_BISD;GenerateProjectFiles;

#This will delete these folders: Binaries, Intermediate, Saved. Proceed with caution.
[Desktop Action CleanCachesFolder_BIS]
Name=Delete Cache (Bin.,Inte.,Saved)
Icon=folder
Exec=/bin/sh -c 'for f in Binaries Intermediate Saved; do rm -r \$f; done'

#This will delete these folders: Binaries, Intermediate, Saved, DerivedDataCache. Proceed with caution.
[Desktop Action CleanCachesFolder_BISD]
Name=Delete Cache (Bin.,Inte.,Saved.,Deri.)
Icon=folder
Exec=/bin/sh -c 'for f in Binaries Intermediate Saved DerivedDataCache; do rm -r \$f; done'

#This will generate project files for Visual Studio Code
[Desktop Action GenerateProjectFiles]
Name=Generate Project Files for VS Code
Icon=visual-studio-code
Exec="$projectGenerator" -projectfiles -project="%u" -game -engine -progress
EOF
fi
}

if [ $SERVICE_MENU == "true" ]; then
    if [[ -f /usr/bin/dolphin ]]; then
        echo "Copying to $SHARE_DIR/kio/servicemenus/$SERVICE_MENU_FILE"
        create_service_menu_for_dolphin
        mkdir -p "$SHARE_DIR/kio/servicemenus/"
        install -Dm755 "$RES_DIR/$SERVICE_MENU_FILE" "$SHARE_DIR/kio/servicemenus/$SERVICE_MENU_FILE"
        
        echo 'Service Menu file creation is done'
        echo
    fi

fi

echo 'Installation done!'
