#!/bin/bash

docker pull kalilinux/kali-rolling

chmod +x ./docker/build_docker.sh
./docker/build_docker.sh


mkdir -p lab

chmod +x start.sh