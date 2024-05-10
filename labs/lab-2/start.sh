#!/bin/bash

clear

sudo python krack-mininet-client.py

if [ $? -eq 1 ]; then
    clear
    sudo python krack-mininet-client.py
fi

sudo mn -c