#! /bin/bash

echo "********************************************************************************"
echo "* Installing dependencies                                                      *"
echo "********************************************************************************"
cd ~
sudo apt install cmake autoconf build-essential libsdl2-dev libsdl2-gfx-dev libsdl2-ttf-dev libvorbis-dev libsdl2-image-dev autotools-dev libtool --no-install-recommends -y

echo "********************************************************************************"
echo "* Cloning repo and building                                                    *"
echo "********************************************************************************"
git clone https://github.com/DirtBagXon/hypseus-singe.git
cd hypseus-singe/src
cmake .
make -j

echo "********************************************************************************"
echo "* Preparing application direct                                                 *"
echo "********************************************************************************"
mkdir -p ~/Applications/hypseus-singe
cp -r ../fonts ~/Applications/hypseus-singe
cp -r ../roms ~/Applications/hypseus-singe
cp -r ../sound ~/Applications/hypseus-singe
cp -r ../pics ~/Applications/hypseus-singe
cp hypseus ~/Applications/hypseus-singe/hypseus.bin

echo "********************************************************************************"
echo "* Installation complete                                                        *"
echo "********************************************************************************"
echo "Check the ES-DE Userguide for detailed instructions:"
echo "https://gitlab.com/es-de/emulationstation-de/-/blob/master/USERGUIDE.md#hypseus-singe-daphne"
