#!/bin/bash

# Run with sudo
if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root!" >&2
    exit 1
fi

# Instal system dependencies
echo -e "\033[1;32mInstalling dependencies...\033[0m"
sudo apt update
sudo apt install -y git libnl-3-dev libnl-genl-3-dev pkg-config libssl-dev net-tools git sysfsutils virtualenv wireshark arping openvswitch-switch

# Install mininet
echo -e "\033[1;32mInstalling mininet...\033[0m"
sudo mininet-wifi/util/install.sh -Wln3fv

# Patch krackattacks
echo -e "\033[1;32mPatching krackattacks scripts...\033[0m"
new_interface="ap1-wlan0"
sed -i "s/interface=.*/interface=$new_interface/" krackattacks-scripts/hostapd/hostapd.conf

new_line='		subprocess.call(["iw", self.nic_mon, "del"])'
sed -i "/if self.sock_eth: self.sock_eth.close()/a\\$new_line" krackattacks-scripts/krackattack/krack-test-client.py

# Setup krackattacks
echo -e "\033[1;32mSetup krackattacks...\033[0m"
git clone git://w1.fi/hostap.git krackattacks-scripts/hostap-wpa_supplicant-2.3
git clone git://w1.fi/hostap.git krackattacks-scripts/hostap-wpa_supplicant-2.5

cp .config krackattacks-scripts/wpa_supplicant/.config
cp .config krackattacks-scripts/hostap-wpa_supplicant-2.3/wpa_supplicant/.config
cp .config krackattacks-scripts/hostap-wpa_supplicant-2.5/wpa_supplicant/.config

echo "src/common/attacks.h" > krackattacks-scripts/attacks.h

echo -e "\033[1;32mRunning build.sh...\033[0m"
(cd ./krackattacks-scripts/krackattack/ && ./build.sh)

echo -e "\033[1;32mRunning pysetup.sh...\033[0m"
(cd ./krackattacks-scripts/krackattack/ && ./pysetup.sh)

sudo ./krackattacks-scripts/krackattack/disable-hwcrypto.sh

# Reboot
#sudo reboot
echo -e "\033[1;32mReboot to apply changes\033[0m"