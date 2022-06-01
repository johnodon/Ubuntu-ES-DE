#!/bin/bash

wget -O /home/$USER/latest_steam_deck_appimage.txt https://gitlab.com/es-de/emulationstation-de/-/raw/master/es-app/assets/latest_steam_deck_appimage.txt
APPIMAGELINK=$(cat /home/arcade/latest_steam_deck_appimage.txt | head -3 | tail -1)
ESCOMMAND=$(ps -eo args | grep EmulationStation-DE | head -1)
echo "$ESCOMMAND"
APPIMAGEFILE=$(ps -eo args | grep EmulationStation-DE | head -1 | tail -1)
APPIMAGEFILE2=${APPIMAGEFILE% *}
echo "$APPIMAGEFILE2"
[ -f "$APPIMAGEFILE2.old" ] && rm "$APPIMAGEFILE2.old"
pkill -f -e EmulationStatio
[ -f "$APPIMAGEFILE2" ] && mv "$APPIMAGEFILE2" "$APPIMAGEFILE2.old"
wget -O "$APPIMAGEFILE2" $APPIMAGELINK &> ~/output.txt
chmod +x "$APPIMAGEFILE2"
sleep 2
$ESCOMMAND &
exit 0
