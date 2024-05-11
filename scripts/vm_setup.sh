#!/bin/bash

GREEN="\033[1;32m"
RESET="\033[0m"

# Set netsec user as root
su root -c '
if [ $(sudo cat /etc/sudoers | grep -q "netsec ALL=(ALL:ALL) ALL" ; echo $?) -eq 1 ]
then
    echo "netsec ALL=(ALL:ALL) ALL" >> /etc/sudoers
fi
'

# Run without sudo
if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root!" >&2
    exit 1
fi

# Install system dependencies
echo -e "${GREEN}Installing dependencies...${RESET}"
sudo apt update
sudo apt install -y git libnl-3-dev libnl-genl-3-dev pkg-config libssl-dev net-tools git sysfsutils virtualenv wireshark arping openvswitch-switch python3-venv

# Install mininet
echo -e "${GREEN}Installing mininet...${RESET}"
sudo ../mininet-wifi/util/install.sh -Wln3fv

# Patch krackattacks
echo -e "${GREEN}Patching krackattacks scripts...${RESET}"
new_interface="ap1-wlan0"
sed -i "s/interface=.*/interface=$new_interface/" ../krackattacks-scripts/krackattack/hostapd.conf

new_interface="sta1-wlan0"
sed -i "s/interface=.*/interface=$new_interface/" ../krackattacks-scripts/hostapd/hostapd.conf

new_line='		subprocess.call(["iw", self.nic_mon, "del"])'
sed -i "/if self.sock_eth: self.sock_eth.close()/a\\$new_line" ../krackattacks-scripts/krackattack/krack-test-client.py

# Setup krackattacks
echo -e "${GREEN}Setup krackattacks...${RESET}"
wget https://w1.fi/cgit/hostap/snapshot/hostap_2_5.zip
unzip hostap_2_5.zip
mv hostap_2_5 ../krackattacks-scripts/hostap-wpa_supplicant-2.5
unzip hostap_2_5.zip

wget https://w1.fi/cgit/hostap/snapshot/hostap_2_10.zip
unzip hostap_2_10.zip
mv hostap_2_10 ../krackattacks-scripts/hostap-wpa_supplicant-2.10
unzip hostap_2_10.zip

cp ../config/config ../krackattacks-scripts/wpa_supplicant/.config
cp ../config/config ../krackattacks-scripts/hostap-wpa_supplicant-2.3/wpa_supplicant/.config
cp ../config/config ../krackattacks-scripts/hostap-wpa_supplicant-2.5/wpa_supplicant/.config

echo -e "${GREEN}Running build.sh...${RESET}"
(cd ../krackattacks-scripts/krackattack/ && ./build.sh)

echo -e "${GREEN}Running pysetup.sh...${RESET}"
(cd ../krackattacks-scripts/krackattack/ && ./pysetup.sh)

echo -e "${GREEN}Running disable-hwcrypto.sh...${RESET}"
sudo ../krackattacks-scripts/krackattack/disable-hwcrypto.sh

echo -e "${GREEN}Installing wpa_supplicant 2.10...${RESET}"
(cd ../krackattacks-scripts/hostap-wpa_supplicant-2.3/wpa_supplicant/ && make clean && make && sudo make install)

# chmod .sh files
echo -e "${GREEN}Finishing...${RESET}"
chmod +x ../launcher.sh
chmod +x ../labs/lab-0/start.sh
chmod +x ../labs/lab-1/start.sh
chmod +x ../labs/lab-2/start.sh

# Reboot
echo -e "${GREEN}Reboot your computer to apply the changes${RESET}"
