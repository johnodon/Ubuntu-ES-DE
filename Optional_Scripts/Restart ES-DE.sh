#!/bin/bash

# Declare variables
ESDECOMMAND=$(ps -eo args | grep EmulationStation-DE | head -1 | tail -1)

# Kill ES-DE
pkill -f -e EmulationStatio > /dev/null 2>&1

# Start ES-DE
sleep 2
$ESDECOMMAND > /dev/null 2>&1 &
