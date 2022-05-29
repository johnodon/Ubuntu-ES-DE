#! /bin/bash

echo "********************************************************************************"
echo "* Installing RetroArch                                                         *"
echo "********************************************************************************"
sudo add-apt-repository ppa:libretro/stable -y && sudo apt-get update && sudo apt-get install retroarch -y

echo "********************************************************************************"
echo "* Installation complete                                                        *"
echo "********************************************************************************"
