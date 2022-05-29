#! /bin/bash

echo "********************************************************************************"
echo "* Disabling sudo password prompt for current user                              *"
echo "********************************************************************************"
sudo echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/dont-prompt-$USER-for-sudo-password"

echo "********************************************************************************"
echo "* Updating/Upgrading                                                           *"
echo "********************************************************************************"
sudo apt update -y && sudo apt upgrade -y

echo "********************************************************************************"
echo "* Installing dependencies                                                      *"
echo "********************************************************************************"
sudo apt install openbox obconf unzip xmlstarlet scrot openssh-server fuse --no-install-recommends -y

echo "********************************************************************************"
echo "* Downloading ES-DE AppImage                                                   *"
echo "********************************************************************************"
wget -O EmulationStation-DE-x64_Current.AppImage  https://gitlab.com/es-de/emulationstation-de/-/package_files/40176633/download
chmod +x EmulationStation-DE-x64_Current.AppImage

echo "********************************************************************************"
echo "* Configuring Openbox session to autostart ES-DE                               *"
echo "********************************************************************************"
mkdir -p /home/$USER/.config/openbox && echo "~/EmulationStation-DE-x64_Current.AppImage --no-splash" > /home/$USER/.config/openbox/autostart

echo "********************************************************************************"
echo "* Installing RetroArch                                                         *"
echo "********************************************************************************"
sudo add-apt-repository ppa:libretro/stable -y && sudo apt-get update && sudo apt-get install retroarch -y

echo "********************************************************************************"
echo "* Installtion complete                                                         *"
echo "********************************************************************************"
