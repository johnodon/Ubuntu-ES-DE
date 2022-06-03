#!/bin/bash

# This script will update the ES-DE AppImage with the current version from the Gitlab repository.

# Declare variables
APPIMAGELINK=$(curl https://gitlab.com/es-de/emulationstation-de/-/raw/master/es-app/assets/latest_steam_deck_appimage.txt | tail -1)
ESDECOMMAND=$(ps -eo args | grep EmulationStation-DE | head -1)
APPIMAGEFILE=${ESDECOMMAND% *}

# Delete backup of AppImage if exists
[ -f "$APPIMAGEFILE.old" ] && rm "$APPIMAGEFILE.old"

# Kill ES-DE
pkill -f -e EmulationStatio > /dev/null 2>&1

# Create backup of AppImage
[ -f "$APPIMAGEFILE" ] && mv "$APPIMAGEFILE" "$APPIMAGEFILE.old"

# Download latest AppImage and set to executable
wget -O "$APPIMAGEFILE" $APPIMAGELINK > /dev/null 2>&1
chmod +x "$APPIMAGEFILE"

# Start ES-DE
sleep 2
$ESDECOMMAND > /dev/null 2>&1 &
