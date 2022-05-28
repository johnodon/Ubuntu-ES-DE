#! /bin/bash
sudo echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/dont-prompt-$USER-for-sudo-password"   # disables prompts for password for sudo
sudo apt update -y && sudo apt upgrade -y
sudo apt install openbox obconf git dialog unzip xmlstarlet samba mpv dos2unix mc scrot openssh-server fuse --no-install-recommends -y
#sudo apt install build-essential libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev libvorbis-dev libsdl2-image-dev autotools-dev     # uncomment this line if you plan to compile hypseus
wget -O EmulationStation-DE-x64_Current.AppImage  https://gitlab.com/es-de/emulationstation-de/-/package_files/40176633/download
chmod +x EmulationStation-DE-x64_Current.AppImage
sudo add-apt-repository ppa:libretro/stable -y && sudo apt-get update && sudo apt-get install retroarch -y
mkdir /home/$USER/.config/openbox && echo "~/EmulationStation-DE-x64_Current.AppImage --no-splash" > /home/$USER/.config/openbox/autostart
