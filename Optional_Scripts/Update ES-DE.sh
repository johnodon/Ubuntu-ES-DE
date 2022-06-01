
#!/bin/bash

# Declare variables
APPIMAGELINK=$(curl https://gitlab.com/es-de/emulationstation-de/-/raw/master/es-app/assets/latest_steam_deck_appimage.txt | tail -1)
ESCOMMAND=$(ps -eo args | grep EmulationStation-DE | head -1)
APPIMAGEFILE=$(ps -eo args | grep EmulationStation-DE | head -1 | tail -1)
APPIMAGEFILE2=${APPIMAGEFILE% *}

# Dlete backup of AppImage if exists
[ -f "$APPIMAGEFILE2.old" ] && rm "$APPIMAGEFILE2.old"

# Kill ES-DE
pkill -f -e EmulationStatio

# Create backup of AppImage
[ -f "$APPIMAGEFILE2" ] && mv "$APPIMAGEFILE2" "$APPIMAGEFILE2.old"

# Download latest AppImage and set to executable
wget -O "$APPIMAGEFILE2" $APPIMAGELINK &> /dev/null
chmod +x "$APPIMAGEFILE2"

# Start ES-DE
sleep 2
$ESCOMMAND &

exit 0
