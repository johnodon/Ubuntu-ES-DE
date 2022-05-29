#! /bin/bash

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
    apt update -y && sudo apt upgrade -y
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
 
# Configure Openbox to autostart ES-DE
function configure_openbox() {
    echo "--------------------------------------------------------------------------------"
    echo "| Configuring Openbox to autostart ES-DE"
    echo "--------------------------------------------------------------------------------"
    mkdir -p /home/$USER/.config/openbox && echo "~/EmulationStation-DE-x64_Current.AppImage --no-splash" > /home/$USER/.config/openbox/autostart
    chown -R $USER:$USER /home/$USER/.config/openbox
    echo -e "FINISHED configure_openbox \n\n"

echo "********************************************************************************"
echo "* Installtion complete                                                         *"
echo "********************************************************************************"



### Base Installation ###
function base-installation() {
    disable_sudo_password
    update_upgrade
    install_dependencies
    install_esde
    configure_openbox
    install_esde
}


### Optional Packages Installation ###
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
