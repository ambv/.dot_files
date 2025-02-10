#!/bin/zsh
echo "Turn wifi off in system settings/Wifi first"
RNDMAC=`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`
echo "changing to $RNDMAC"
sudo networksetup -setairportpower en0 on; sudo ifconfig en0 ether $RNDMAC;sudo networksetup -detectnewhardware
