#! /bin/bash

# Computed variables
USER="$SUDO_USER"
USER_HOME="/home/$USER"
SCRIPT_PATH="$(realpath $0)"
SCRIPT_DIR="$(dirname $SCRIPT_PATH)"
SCRIPT_FILE="$(basename $SCRIPT_PATH)"
LOG_FILE="$SCRIPT_DIR/$(basename $0 .sh)-$(date +"%Y%m%d_%H%M%S").log"

################################################################### START PREFLIGHT SECTION ###################################################################

# Make sure the user is running the script via sudo
check_perms() {
echo "--------------------------------------------------------------------------------"
echo "| Checking permissions..."
echo "--------------------------------------------------------------------------------"
if [ -z "$SUDO_USER" ]; then
    echo "Installing Ubuntu-ES-DE requires sudo privileges. Please run with: sudo $0"
    exit 1
fi
# Don't allow the user to run this script from the root account.
if [[ "$SUDO_USER" == root ]]; then
    echo "Ubuntu-ES-DE should not be installed by the root user.  Please run as normal user using sudo."
    exit 1
fi
}

# Menu to present optional packages
select_options() {
PACKAGES=$(dialog --no-tags --clear --backtitle "Main Menu" --title "Optional Packages" \
    --checklist "This script will install ES-DE and its dependencies even if no optional packages are selected. \
    Use arrown keys to move up/down and SPACE to select/deselct optional packages. Select OK and press [ENTER] when finished.  \
    Select CANCEL and press [ENTER] to terminate the script" 30 100 30 \
    install_extra_tools "Install extra tools" off install_hypseus_singe "Install Hypseus-Singe emulator" off install_retroarch \
    "Install RetroArch" off 3>&1 1>&2 2>&3)
response=$?
if [ "$response" == "1" ] ; then
    clear
    echo "Installation cancelled by user. $LOG_FILE has been deleted."
    rm $LOG_FILE
    exit
fi
}

# Output to both console and log file
enable_logging() {
    echo "--------------------------------------------------------------------------------"
    echo "| Saving console output to '$LOG_FILE'"
    echo "--------------------------------------------------------------------------------"
    touch $LOG_FILE
    exec > >(tee $LOG_FILE)
    sleep 2
}

#################################################################### END PREFLIGHT SECTION ####################################################################



################################################################# START BASE INSTALLATION SECTION ##################################################################

# Create file in sudoers.d directory and disable password prompt
disable_sudo_password() {
    echo "--------------------------------------------------------------------------------"
    echo "| Disabling the sudo password prompt"
    echo "--------------------------------------------------------------------------------"
    echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER-no-password-prompt
    chmod 0440 /etc/sudoers.d/$USER-no-password-prompt
    echo -e "FINISHED disable_sudo_password \n\n"
    sleep 2
}

# Update OS with latest packages
update_upgrade() {
    echo "--------------------------------------------------------------------------------"
    echo "| Updating OS with latest packages"
    echo "--------------------------------------------------------------------------------"
    apt update -y && apt upgrade -y
    echo -e "FINISHED update_upgrade \n\n"
    sleep 2
}

# Install dependencies
install_dependencies() {
    echo "--------------------------------------------------------------------------------"
    echo "| Updating OS with latest packages"
    echo "--------------------------------------------------------------------------------"
    apt install openbox obconf unzip xmlstarlet scrot openssh-server fuse --no-install-recommends -y
    echo -e "FINISHED install_dependencies \n\n"
    sleep 2
}

# Install EmulationStation Desktop Edition
install_esde() {
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
configure_openbox() {
    echo "--------------------------------------------------------------------------------"
    echo "| Configuring Openbox to autostart ES-DE"
    echo "--------------------------------------------------------------------------------"
    mkdir -p /home/$USER/.config/openbox && echo "~/EmulationStation-DE-x64_Current.AppImage --no-splash" > /home/$USER/.config/openbox/autostart
    chown -R $USER:$USER /home/$USER/.config/openbox
    echo -e "FINISHED configure_openbox \n\n"
}

################################################################# END BASE INSTALLATION SECTION ##################################################################



################################################################# START OPTIONAL INSTALLATION SECTION ##################################################################

optional_packages() {
    select_options
    for SELECTION in $PACKAGES; do
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

# Install Extra Tools
install_extra_tools() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing extra tools"
    echo "--------------------------------------------------------------------------------"
    apt install mc thunar mpv samba dos2unix git dialog --no-install-recommends -y
    echo -e "FINISHED install_extra_tools \n\n"
}

# Install RetroArch
install_retroarch() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing RetroArch"
    echo "--------------------------------------------------------------------------------"
    add-apt-repository ppa:libretro/stable -y && apt update && apt install retroarch -y
    echo -e "FINISHED install_retroarch \n\n"
}

# Install Hypseus-Singe
install_hypseus_singe() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing Hypseus-Singe"
    echo "--------------------------------------------------------------------------------"
    cd ~
    apt install cmake autoconf build-essential libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev libvorbis-dev \
    libsdl2-image-dev autotools-dev libtool --no-install-recommends -y
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

################################################################# END OPTIONAL INSTALLATION SECTION ##################################################################



################################################################### START CLEANUP SECTION ###################################################################

# Repair any permissions that might have been incorrectly set
repair_permissions() {
    echo "--------------------------------------------------------------------------------"
    echo "| Repairing file & folder permissions underneath $USER_HOME"
    echo "| by changing owner to $USER on all files and directories under $USER_HOME"
    echo "--------------------------------------------------------------------------------"
    chown -R $USER:$USER $USER_HOME/
    echo -e "FINISHED repair_permissions \n\n"
    sleep 2
}

# Remove unneeded packages
remove_unneeded_packages() {
    echo "--------------------------------------------------------------------------------"
    echo "| Autoremoving any unneeded packages"
    echo "--------------------------------------------------------------------------------"
    apt-get update && apt-get -y upgrade
    apt-get -y autoremove
    echo -e "FINISHED remove_unneeded_packages \n\n"
    sleep 2
}

#################################################################### END CLEANUP SECTION ####################################################################

### Preflight Functions ###
preflight() {
    check_perms
    enable_logging
}


### BASE Installation Functions ###
base_installation() {
    disable_sudo_password
    update_upgrade
    install_dependencies
    install_esde
    configure_openbox
}

### OPTIONAL Installation Functions ###
optional_installation() {
    optional_packages
}


### Cleanup Functions ###
cleanup() {
    repair_permissions
    remove_unneeded_packages
}

preflight
base_installation
optional_installation
cleanup

echo "********************************************************************************"
echo "* Installtion complete"
echo "********************************************************************************"
