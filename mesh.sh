#!/bin/bash

# Install dependencies
sudo apt-get install -y batctl libnl-3-dev libnl-genl-3-dev

# Stop conflicting network services
sudo systemctl stop dhcpcd
sudo systemctl stop wpa_supplicant

# Load B.A.T.M.A.N. kernel module
sudo modprobe batman-adv

# Configure wlan0 for ad-hoc mesh networking
sudo ip link set wlan0 down
sudo iwconfig wlan0 mode ad-hoc
sudo iwconfig wlan0 essid 'mesh-network'
sudo iwconfig wlan0 ap any
sudo iwconfig wlan0 channel 1
sudo ip link set wlan0 up

# Set MTU (only if supported by your hardware)
if sudo ifconfig wlan0 mtu 1500; then
  echo "MTU set to 1500"
else
  echo "MTU setting failed — continuing without it"
fi

# Attach wlan0 to the batman virtual interface
sudo batctl if add wlan0
sudo ip link set up dev bat0

# Set a static IP on bat0 (must be unique per device)
sudo ifconfig bat0 192.168.1.2/24  # Change last octet per device
