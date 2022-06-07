#!/bin/bash

# Declare variables
ESDECOMMAND=$(ps -eo args | grep EmulationStation-DE | head -1 | tail -1)

# Kill ES-DE
pkill -f -e EmulationStatio > /dev/null 2>&1

# Start gnome-terminal
sleep 2
gnome-terminal --full-screen -- /bin/sh -c 'sudo apt update && sudo apt upgrade -y; exec bash'
