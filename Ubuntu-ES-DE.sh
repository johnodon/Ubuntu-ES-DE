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

# Menu to present installation options
main_menu() {
PACKAGES=$(dialog --no-tags --clear --backtitle "Main Menu" --title "Optional Packages" \
    --checklist "Use arrown keys to move up/down and SPACE to select/deselct packages. \
    Select OK and press [ENTER] when finished. \
    Select CANCEL and press [ENTER] to terminate the script" 30 100 30 \
    initial_install "Perform initial install (do this only the first time)" on \
    install_intel_driver "Install latest Intel GPU driver" off \
    install_nvidia_driver "Install latest Nvidia GPU driver" off \
    install_mesa "Install latest version of Mesa" off \
    install_extra_tools "Install extra tools" off \
    install_retroarch "Install RetroArch" off \
    install_steam "Install Steam" off \
    install_steam "Install Google Chrome" off \
    install_hypseus_singe "Install Hypseus-Singe emulator" off \
    3>&1 1>&2 2>&3)
response=$?
if [ "$response" == "1" ] ; then
    clear
    echo "Installation cancelled by user."
    exit
fi
}

# Output to log file
enable_logging() {
    echo "--------------------------------------------------------------------------------"
    echo "| Saving console output to '$LOG_FILE'"
    echo "--------------------------------------------------------------------------------"
    touch $LOG_FILE
    exec > >(tee $LOG_FILE)
    sleep 2
}

#################################################################### END PREFLIGHT SECTION ####################################################################



#################################################################### START PACKAGE SECTION ####################################################################

# Readout package selections
package_selection() {
    for SELECTION in $PACKAGES; do
        case $SELECTION in
        initial_install)
            initial_install
            ;;
        install_intel_driver)
            install_intel_driver
            ;;
        install_nvidia_driver)
            install_nvidia_driver
            ;;
        install_mesa)
            install_mesa
            ;;
        install_extra_tools)
            install_extra_tools
            ;;
        install_retroarch)
            install_retroarch
            ;;
        install_steam)
            install_steam
            ;;
        install_chrome)
            install_chrome
            ;;
        install_hypseus_singe)
            install_hypseus_singe
            ;;
     esac
     done
 }

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
    apt-get update -y && apt-get upgrade -y
    echo -e "FINISHED update_upgrade \n\n"
    sleep 2
}

# Hide Boot Messages
hide_boot_messages() {
    echo "--------------------------------------------------------------------------------"
    echo "| Hiding boot messages"
    echo "--------------------------------------------------------------------------------"
    # Hide kernel messages and blinking cursor via GRUB
    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=".*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=2 fsck.mode=skip vt.global_cursor_default=0 video=1920x1080"/g' /etc/default/grub
    update-grub
    # Disable motd
    touch $USER_HOME/.hushlogin
    chown $USER:$USER $USER_HOME/.hushlogin
    echo -e "FINISHED hide_boot_messages \n\n"
    sleep 2
}

# Install dependencies
install_dependencies() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing dependencies"
    echo "--------------------------------------------------------------------------------"
    apt-get install openbox obconf unzip xmlstarlet scrot openssh-server fuse curl p7zip-full --no-install-recommends -y
    echo -e "FINISHED install_dependencies \n\n"
    sleep 2
}

# Install EmulationStation Desktop Edition
install_esde() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing EmulationStation Desktop Edition"
    echo "--------------------------------------------------------------------------------"
    mkdir -p $USER_HOME/Applications/ && cd $USER_HOME/Applications
    wget -O EmulationStation-DE-2.0.0-alpha-2022-09-28-x64.AppImage https://gitlab.com/es-de/emulationstation-de/-/package_files/58618844/download > /dev/null 2>&1
    chmod +x *
    chown $USER:$USER *
    cd $USER_HOME
    echo -e "FINISHED install_esde \n\n"
}

# Configure Openbox to autostart ES-DE
configure_openbox() {
    echo "--------------------------------------------------------------------------------"
    echo "| Configuring Openbox to autostart ES-DE and hide title bar"
    echo "--------------------------------------------------------------------------------"
    #mkdir -p $USER_HOME/.config/openbox && echo "~/Applications/EmulationStation*.AppImage" > $USER_HOME/.config/openbox/autostart
    cp -avr $SCRIPT_DIR/files/.config $USER_HOME
    chown -R $USER:$USER $USER_HOME/.config/openbox
    echo -e "FINISHED configure_openbox \n\n"
}

# Install latest Intel GPU driver
install_intel_driver() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing latest Intel GPU driver"
    echo "--------------------------------------------------------------------------------"
    add-apt-repository -y ppa:ubuntu-x-swat/updates
    apt-get update && apt-get -y upgrade
    echo -e "FINISHED install_intel_driver \n\n"
}

# Install latest Nvidia GPU driver
install_nvidia_driver() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing latest Nvidia GPU driver"
    echo "--------------------------------------------------------------------------------"
    apt-get install -y ubuntu-drivers-common
    add-apt-repository -y ppa:graphics-drivers/ppa
    ubuntu-drivers autoinstall
    echo -e "FINISHED install_nvidia_driver \n\n"
}

# Install latest version of Mesa
install_mesa() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing latest version of Mesa"
    echo "--------------------------------------------------------------------------------"
    add-apt-repository -y ppa:kisak/kisak-mesa
    apt-get update && apt-get upgrade -y
    echo -e "FINISHED install_mesa \n\n"
}

# Install Extra Tools
install_extra_tools() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing extra tools"
    echo "--------------------------------------------------------------------------------"
    apt-get install mc thunar mpv samba dos2unix git dialog htop mesa-utils xrdp x11vnc blueman net-tools --no-install-recommends -y
    echo -e "FINISHED install_extra_tools \n\n"
}

# Install RetroArch and latest assets/cores
install_retroarch() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing RetroArch"
    echo "--------------------------------------------------------------------------------"
    add-apt-repository ppa:libretro/stable -y && apt-get update && apt-get install retroarch -y
    mkdir -p $USER_HOME/.config/retroarch/cores
    mkdir -p $USER_HOME/.config/retroarch/assets
    curl -o $USER_HOME/Downloads/RetroArch_cores.7z http://buildbot.libretro.com/nightly/linux/x86_64/RetroArch_cores.7z \
	-o $USER_HOME/Downloads/assets.zip https://buildbot.libretro.com/assets/frontend/assets.zip \
	-o $USER_HOME/Downloads/info.zip https://buildbot.libretro.com/assets/frontend/info.zip \
	-o $USER_HOME/Downloads/autoconfig.zip https://buildbot.libretro.com/assets/frontend/autoconfig.zip \
	-o $USER_HOME/Downloads/cheats.zip https://buildbot.libretro.com/assets/frontend/cheats.zip \
	-o $USER_HOME/Downloads/database-cursors.zip https://buildbot.libretro.com/assets/frontend/database-cursors.zip \
	-o $USER_HOME/Downloads/database-rdb.zip https://buildbot.libretro.com/assets/frontend/database-rdb.zip \
	-o $USER_HOME/Downloads/overlays.zip https://buildbot.libretro.com/assets/frontend/overlays.zip \
	-o $USER_HOME/Downloads/shaders_cg.zip hhttps://buildbot.libretro.com/assets/frontend/shaders_cg.zip \
	-o $USER_HOME/Downloads/shaders_glsl.zip https://buildbot.libretro.com/assets/frontend/shaders_glsl.zip \
	-o $USER_HOME/Downloads/shaders_slang.zip hhttps://buildbot.libretro.com/assets/frontend/shaders_slang.zip	
    #curl -o $USER_HOME/Downloads/assets.zip https://buildbot.libretro.com/assets/frontend/assets.zip
    #curl -o $USER_HOME/Downloads/info.zip https://buildbot.libretro.com/assets/frontend/info.zip
    7z x -o$USER_HOME/Downloads $USER_HOME/Downloads/RetroArch_cores.7z
    mv -f $USER_HOME/Downloads/RetroArch-Linux-x86_64/RetroArch-Linux-x86_64.AppImage.home/.config/retroarch/cores/* $USER_HOME/.config/retroarch/cores/
    7z x -o$USER_HOME/Downloads/assets $USER_HOME/Downloads/assets.zip
    mv -f $USER_HOME/Downloads/assets/* $USER_HOME/.config/retroarch/assets/
    7z x -o$USER_HOME/Downloads/info $USER_HOME/Downloads/info.zip
    mv -f $USER_HOME/Downloads/info/* $USER_HOME/.config/retroarch/cores/
    chown -R $USER:$USER $USER_HOME/.config/retroarch/
    cd $USER_HOME
    echo -e "FINISHED install_retroarch \n\n"
}

# Install Steam
install_steam() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing Steam"
    echo "--------------------------------------------------------------------------------"
    apt-get install steam --no-install-recommends -y
    echo -e "FINISHED install_steam \n\n"
}

# Install Google Chrome
install_chrome() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing Google Chrome"
    echo "--------------------------------------------------------------------------------"
    cd $USER_HOME/Downloads
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt install ./google-chrome-stable_current_amd64.deb -y
    rm google-chrome-stable_current_amd64.deb
    echo -e "FINISHED install_chrome \n\n"
}

# Install Hypseus-Singe
install_hypseus_singe() {
    echo "--------------------------------------------------------------------------------"
    echo "| Installing Hypseus-Singe"
    echo "--------------------------------------------------------------------------------"
    cd $USER_HOME
    apt-get install cmake autoconf build-essential libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev libvorbis-dev \
    libsdl2-image-dev autotools-dev libtool automake --no-install-recommends -y
    #wget -O hypseus-singe_2.8.2a_ES-DE.tar.gz https://gitlab.com/es-de/emulationstation-de/-/package_files/41533436/download
    #tar -xvf hypseus-singe_2.8.2a_ES-DE.tar.gz -C $USER_HOME/Applications/
    #rm $USER_HOME/hypseus-singe_2.8.2a_ES-DE.tar.gz
    git clone https://github.com/DirtBagXon/hypseus-singe.git
    cd $USER_HOME/hypseus-singe/src
    cmake .
    make -j
    mkdir -p $USER_HOME/Applications/hypseus-singe
    cp -r ../fonts $USER_HOME/Applications/hypseus-singe
    cp -r ../roms $USER_HOME/Applications/hypseus-singe
    cp -r ../sound $USER_HOME/Applications/hypseus-singe
    cp -r ../pics $USER_HOME/Applications/hypseus-singe
    cp hypseus $USER_HOME/Applications/hypseus-singe/hypseus.bin
    echo -e "FINISHED install_hypseus_singe \n\n"
}

##################################################################### END PACKAGE SECTION #####################################################################



#################################################################### START CLEANUP SECTION ####################################################################

# Fix known quirks
fix_quirks() {
    echo "--------------------------------------------------------------------------------"
    echo "| Fixing any known quirks"
    echo "--------------------------------------------------------------------------------"
    echo " "
    echo "+-------------------------------------------------------------------------------"
    echo "| Add $USER user to the additional groups"
    echo "+-------------------------------------------------------------------------------"
    usermod -a -G input $USER
    usermod -a -G audio $USER
    usermod -a -G video $USER
    echo -e "FINISHED fix_quirks \n\n"
    sleep 2
}

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

##################################################################### END CLEANUP SECTION #####################################################################

### Preflight Functions ###
preflight() {
    check_perms
    main_menu
    enable_logging
}


### BASE Installation Functions ###
initial_install() {
    disable_sudo_password
    update_upgrade
    hide_boot_messages
    install_dependencies
    install_esde
    configure_openbox
}

### OPTIONAL Installation Functions ###
installation() {
    package_selection
}


### Cleanup Functions ###
cleanup() {
    fix_quirks
    repair_permissions
    remove_unneeded_packages
}

preflight
installation
cleanup

echo "--------------------------------------------------------------------------------"
echo "| Installtion complete.  Check $LOG_FILE for details"
echo "--------------------------------------------------------------------------------"
