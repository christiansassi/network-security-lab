#!/bin/bash

docker pull kalilinux/kali-rolling

chmod +x ./docker/build_docker.sh
bash docker/build_docker.sh

mkdir -p lab

SCRIPT_CONTENT='#!/bin/bash
docker run -it -v lab:/network_security_lab/lab network_security_lab_image'

echo "$SCRIPT_CONTENT" > start.sh
chmod +x start.sh
