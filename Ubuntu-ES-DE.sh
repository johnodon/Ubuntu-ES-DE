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
function check_perms() {
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

# Output to both console and log file
function enable_logging() {
    echo "--------------------------------------------------------------------------------"
    echo "| Saving console output to '$LOG_FILE'"
    echo "--------------------------------------------------------------------------------"
    touch $LOG_FILE
    exec > >(tee $LOG_FILE) 2>&1
    sleep 2
}

#################################################################### END PREFLIGHT SECTION ####################################################################


############################################################# START OPTIONALPACKAGES MENU SECTION #############################################################

# Menu to present optional packages
function select_options() {
#resize -s 40 90 > /dev/null #Change window size.
#whiptail --checklist --notags "Please pick one" 10 35 3 install_extra_tools "Install extra tools" off install_retroarch "Install RetroArch" off install_hypeseus_singe "Install Hypseus-Singe" off
PACKAGES=$(dialog --no-tags --clear --backtitle "Additional Package Options..." --title "Optional Packages" --checklist "Use SPACE to select/deselct options and OK when finished." 30 100 30 install_extra_tools "Install extra tools" off install_hypseus_singe "Install Hypseus-Singe emulator" off install_retroarch "Install RetroArch" off 3>&1 1>&2 2>&3)
}

############################################################## END OPTIONALPACKAGES MENU SECTION ##############################################################


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

######################################################### END OPTIONAL PACKAGE INSTALLATION SECTION #########################################################

### Preflight Functions ###
function preflight() {
    check_perms
    enable_logging
}


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
preflight
optional_packages

echo "********************************************************************************"
echo "* Installtion complete"
echo "********************************************************************************"
