
#!/bin/bash

wget -O /home/$USER/latest_steam_deck_appimage.txt https://gitlab.com/es-de/emulationstation-de/-/raw/master/es-app/assets/latest_steam_deck_appimage.txt
APPIMAGELINK=$(cat /home/arcade/latest_steam_deck_appimage.txt | head -3 | tail -1)
[ -f "/home/$USER/EmulationStation-DE-x64_Current.AppImage.old" ] && rm "/home/$USER/EmulationStation-DE-x64_Current.AppImage.old"
pkill -f -e "/home/$USER/EmulationStation-DE-x64_Current.AppImage --no-splash"
[ -f "/home/$USER/EmulationStation-DE-x64_Current.AppImage" ] && mv "/home/$USER/EmulationStation-DE-x64_Current.AppImage" "/home/$USER/EmulationStation-DE-x64_Current.AppImage.old"
wget -O "/home/$USER/EmulationStation-DE-x64_Current.AppImage" "$APPIMAGELINK" &> ~/output.txt
chmod +x "/home/$USER/EmulationStation-DE-x64_Current.AppImage"
sleep 2
/home/$USER/EmulationStation-DE-x64_Current.AppImage --no-splash
