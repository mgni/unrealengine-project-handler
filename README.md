# Unreal Engine Project Handler

## A bash script for Unreal Engine on Linux

This script can automate creation of
- .desktop file
- .uproject file association to the system. So you can open .uproject file by double clicking from file manager
- service menu file for `Dolphin`
-  This script use `xdg-utils`, `python`, `magick` tools. These tools should be preinstalled on the system. Extra icons are included in res/icon/extra/

Download the Unreal Engine and Bridge zip files from \
https://www.unrealengine.com/en-US/linux

Extract to desire location.

Find the "Engine" folder and put these folder and files along with "Engine" folder.

- 📂 res
- 📄 install.sh
- 📄 uninstall.sh


## Installation

Install .desktop and .uproject icons

```bash
  $ chmod +x install.sh && ./install.sh
```

## Uninstallation

Uninstall .desktop and .uproject icons

```bash
  $ chmod +x uninstall.sh && ./uninstall.sh
```

## Execute Unreal Engine from terminal

Open terminal and execute following command

```bash
  $ unrealengine <custom flags>
  example : $ unrealengine -nohighdpi
```
ref:
- https://dev.epicgames.com/documentation/en-us/unreal-engine/command-line-arguments-in-unreal-engine#usefulcommand-linearguments
