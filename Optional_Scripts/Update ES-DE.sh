
#! /bin/bash

if exist /home/$USER/EmulationStation-DE-x64_Current.AppImage.old ; then
    rm /home/$USER/EmulationStation-DE-x64_Current.AppImage.old
fi
pkill -f -e "/home/$USER/EmulationStation-DE-x64_Current.AppImage --no-splash"
sleep 2
mv /home/$USER/EmulationStation-DE-x64_Current.AppImage /home/$USER/EmulationStation-DE-x64_Current.AppImage.old
wget -O /home/$USER/latest_steam_deck_appimage.txt https://gitlab.com/es-de/emulationstation-de/-/raw/master/es-app/assets/latest_steam_deck_appimage.txt
APPIMAGELINK=$(cat /home/$USER/latest_steam_deck_appimage.txt | head -3 | tail -1)
wget -O /home/$USER/EmulationStation-DE-x64_Current.AppImage $APPIMAGELINK
chown $USER:$USER /home/$USER/EmulationStation-DE-x64_Current.AppImage
chmod +x /home/$USER/EmulationStation-DE-x64_Current.AppImage
sleep 2
/home/$USER/EmulationStation-DE-x64_Current.AppImage --no-splash
