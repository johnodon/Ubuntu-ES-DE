#! /bin/bash

if exist /home/$USER/EmulationStation-DE-x64_Current.AppImage.old ; then
    rm /home/$USER/EmulationStation-DE-x64_Current.AppImage.old
fi
mv /home/$USER/EmulationStation-DE-x64_Current.AppImage /home/$USER/EmulationStation-DE-x64_Current.AppImage.old
wget -O /home/$USER/EmulationStation-DE-x64_Current.AppImage  https://gitlab.com/es-de/emulationstation-de/-/package_files/40176633/download
chown $USER:$USER /home/$USER/EmulationStation-DE-x64_Current.AppImage
chmod +x /home/$USER/EmulationStation-DE-x64_Current.AppImage
