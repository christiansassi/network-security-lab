#!/bin/bash

# Run with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "Use sudo!" >&2
    exit 1
fi

# Instal system dependencies
sudo apt update
sudo apt install git libnl-3-dev libnl-genl-3-dev pkg-config libssl-dev net-tools git sysfsutils virtualenv wireshark arping

# Install mininet
sudo mininet-wifi/util/install.sh -Wln3fv

# Patch krackattacks
new_interface="ap1-wlan0"
sed -i "s/interface=.*/interface=$new_interface/" krackattacks-scripts/hostapd/hostapd.conf

new_line='		subprocess.call(["iw", self.nic_mon, "del"])'
sed -i "/if self.sock_eth: self.sock_eth.close()/a\\$new_line" krackattacks-scripts/krackattack/krack-test-client.py

# Setup krackattacks
git clone git://w1.fi/hostap.git krackattacks-scripts/hostap-wpa_supplicant-2.3
git clone git://w1.fi/hostap.git krackattacks-scripts/hostap-wpa_supplicant-2.5

cp .config krackattacks-scripts/wpa_supplicant/.config
cp .config krackattacks-scripts/hostap-wpa_supplicant-2.3/wpa_supplicant/.config
cp .config krackattacks-scripts/hostap-wpa_supplicant-2.5/wpa_supplicant/.config

echo "src/common/attacks.h" > attacks.h

(cd ./krackattacks-scripts/krackattack/ && ./build.sh)
(cd ./krackattacks-scripts/krackattack/ && ./pysetup.sh)

sudo ./krackattacks-scripts/krackattack/disable-hwcrypto.sh

# Reboot
sudo reboot