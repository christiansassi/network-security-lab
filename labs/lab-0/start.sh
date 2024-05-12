#!/bin/bash

clear

xterm -T "CLIENT" -geometry "80x20+0+0" -e "python3 client.py && read -p $'\nPress Enter to close this window...'" &
xterm -T "SERVER" -geometry "80x20+0-0" -e "python3 server.py && read -p $'\nPress Enter to close this window...'" &
xterm -T "ATTACKER" -geometry "80x20-0+0" -e "python3 mitm.py && read -p $'\nPress Enter to close this window...'" &

wait