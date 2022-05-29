#! /bin/bash

echo "********************************************************************************"
echo "* Disabling sudo password prompt for current user                              *"
echo "********************************************************************************"
sudo echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/dont-prompt-$USER-for-sudo-password"   # disables prompts for password for sudo

echo "********************************************************************************"
echo "* Updating/Upgrading                                                           *"
echo "********************************************************************************"
sudo apt update -y && sudo apt upgrade -y

echo "********************************************************************************"
echo "* Installing dependencies                                                      *"
echo "********************************************************************************"
sudo apt install openbox obconf unzip xmlstarlet scrot openssh-server fuse --no-install-recommends -y   # Hard dependencies
#sudo apt install mc thunar mpv samba dos2unix git dialog --no-install-recommends -y  # Uncomment to install additional tools
#sudo apt install build-essential libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev libvorbis-dev libsdl2-image-dev autotools-dev --no-install-recommends -y    # uncomment this line if you plan to compile hypseus

echo "********************************************************************************"
echo "* Downloading ES-DE AppImage                                                   *"
echo "********************************************************************************"
wget -O EmulationStation-DE-x64_Current.AppImage  https://gitlab.com/es-de/emulationstation-de/-/package_files/40176633/download
chmod +x EmulationStation-DE-x64_Current.AppImage

echo "********************************************************************************"
echo "* Installing RetroArch                                                         *"
echo "********************************************************************************"
sudo add-apt-repository ppa:libretro/stable -y && sudo apt-get update && sudo apt-get install retroarch -y

echo "********************************************************************************"
echo "* Configuring Openbox session to autostart ES-DE                               *"
echo "********************************************************************************"
mkdir -p /home/$USER/.config/openbox && echo "~/EmulationStation-DE-x64_Current.AppImage --no-splash" > /home/$USER/.config/openbox/autostart

echo "********************************************************************************"
echo "* Installtion complete                                                         *"
echo "********************************************************************************"
