# Ubuntu-ES-DE

Script to automate the installation on EmulationStation Desktop Edition (https://es-de.org) on Ubuntu 22.04 Desktop, with the end-state user experience nearly identical to a RetroPie installation, but with the power and flexibility of x86.

# What it does...
  - Disables sudo password prompts
  - Installs the minimal OS dependecies needed to install OpenBox and run ES-DE
  - Downloads the ES-DE Appimage and makes it executable
  - Boots directly into OpenBox / ES-DE


# Installing the Base OS
  - Download a copy of Ubuntu 22.04 Desktop
  - May work with other versions but they have not been tested
  - Perform a basic install of Ubuntu with these options
      - Language: your choice
      - Keyboard: your choice
      - Partition Scheme: entire disk (preferred, not required)
      - Timezone: your choice
      - Hostname: your choice
      - Username: your choice
      - Password: your choice
      - Login automatically should be enabled


# Running the ES-DE install script...
  - Log in as the user you chose
  - Open a terminal, download the install script, make it executable and run it
      - `wget -q https://github.com/johnodon/Ubuntu-ES-DE/blob/main/Ubuntu-ES-DE.sh && chmod +x Ubuntu-ES-DE.sh && sudo bash ./Ubuntu-ES-DE.sh`
      - You will need to provide the password for the user

