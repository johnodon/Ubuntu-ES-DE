#! /bin/bash

############################################################### START BASE INSTALLATION SECTION ###############################################################

# Create file in sudoers.d directory and disable password prompt
function disable_sudo_password() {
    echo "--------------------------------------------------------------------------------"
    echo "| Disabling the sudo password prompt"
    echo "--------------------------------------------------------------------------------"
    echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER-no-password-prompt
    chmod 0440 /etc/sudoers.d/$USER-no-password-prompt
    echo -e "FINISHED disable_sudo_password \n\n"
    sleep 2
}

# Update OS with latest packages
function update_upgrade() {
    echo "--------------------------------------------------------------------------------"
    echo "| Updating OS with latest packages"
    echo "--------------------------------------------------------------------------------"
    apt update -y && apt upgrade -y
    echo -e "FINISHED update_upgrade \n\n"
    sleep 2
}

# Install dependencies
function install_dependencies() {
    echo "--------------------------------------------------------------------------------"
    echo "| Updating OS with latest packages"
    echo "--------------------------------------------------------------------------------"
    apt install openbox obconf unzip xmlstarlet scrot openssh-server fuse --no-install-recommends -y
    echo -e "FINISHED install_dependencies \n\n"
    sleep 2
}

# Install EmulationStation Desktop Edition
function install_esde() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing EmulationStation Desktop Edition"
    echo "--------------------------------------------------------------------------------"
    cd ~
    wget -O EmulationStation-DE-x64_Current.AppImage  https://gitlab.com/es-de/emulationstation-de/-/package_files/40176633/download
    chown $USER:$USER ~/EmulationStation-DE-x64_Current.AppImage
    chmod +x EmulationStation-DE-x64_Current.AppImage
    echo -e "FINISHED install_esde \n\n"
}

# Configure Openbox to autostart ES-DE
function configure_openbox() {
    echo "--------------------------------------------------------------------------------"
    echo "| Configuring Openbox to autostart ES-DE"
    echo "--------------------------------------------------------------------------------"
    mkdir -p /home/$USER/.config/openbox && echo "~/EmulationStation-DE-x64_Current.AppImage --no-splash" > /home/$USER/.config/openbox/autostart
    chown -R $USER:$USER /home/$USER/.config/openbox
    echo -e "FINISHED configure_openbox \n\n"
}

############################################################### END BASE INSTALLATION SECTION ###############################################################


######################################################## START OPTIONAL PACKAGE INSTALLATION SECTION ########################################################

# Install Extra Tools
function install_extra_tools() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing extra tools"
    echo "--------------------------------------------------------------------------------"
    apt install mc thunar mpv samba dos2unix git dialog --no-install-recommends -y
    echo -e "FINISHED install_extra_tools \n\n"
}

# Install RetroArch
function install_retroarch() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing RetroArch"
    echo "--------------------------------------------------------------------------------"
    add-apt-repository ppa:libretro/stable -y && apt update && apt install retroarch -y
    echo -e "FINISHED install_retroarch \n\n"
}

# Install Hypseus-Singe
function install_hypseus_singe() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing Hypseus-Singe"
    echo "--------------------------------------------------------------------------------"
    cd ~
    apt install cmake autoconf build-essential libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev libvorbis-dev libsdl2-image-dev autotools-dev libtool --no-install-recommends -y
    git clone https://github.com/DirtBagXon/hypseus-singe.git
    cd hypseus-singe/src
    cmake .
    make -j
    mkdir -p ~/Applications/hypseus-singe
    cp -r ../fonts ~/Applications/hypseus-singe
    cp -r ../roms ~/Applications/hypseus-singe
    cp -r ../sound ~/Applications/hypseus-singe
    cp -r ../pics ~/Applications/hypseus-singe
    cp hypseus ~/Applications/hypseus-singe/hypseus.bin
    echo -e "FINISHED install_hypseus_singe \n\n"
}

######################################################## START OPTIONAL PACKAGE INSTALLATION SECTION ########################################################


### Base Installation Functions ###
function base_installation() {
    disable_sudo_password
    update_upgrade
    install_dependencies
    install_esde
    configure_openbox
}


### Optional Packages Installation Functions ###
function optional_packages() {
    select_options
    for SELECTION in $OPTIONS; do
    case $SELECTION in
    install_extra_tools)
        install_extra_tools
        ;;
    install_hypseus_singe)
        install_hypseus_singe
        ;;
    install_retroarch)
        install_retroarch
        ;;
    esac
    done
}

echo "********************************************************************************"
echo "* Installtion complete"
echo "********************************************************************************"
