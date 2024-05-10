#!/bin/bash

clear

xterm -geometry "80x20+0+0" -e "python3 client.py && read -p ''" &
xterm -geometry "80x20+0-0" -e "python3 server.py && read -p ''" &
xterm -geometry "80x20-0+0" -e "python3 mitm.py && read -p ''" &

wait