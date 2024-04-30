#!/bin/bash

docker pull kalilinux/kali-rolling

chmod +x ./docker/build_docker.sh
./docker/build_docker.sh

mkdir network_security_lab

SCRIPT_CONTENT='#!/bin/bash

docker run -it -v ./network_security_lab:/network_security_lab network_security_lab_image'

echo "$SCRIPT_CONTENT" > start.sh
chmod +x start.sh
