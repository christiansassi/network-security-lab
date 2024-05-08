#!/bin/bash

width=$(tput cols)
height=$(tput lines)

xterm -geometry "$((width / 2))x$((height / 2))+0+0" -e "python3 client.py" &
xterm -geometry "$((width / 2))x$((height / 2))+0-0" -e "python3 server.py" &
xterm -geometry "$((width / 2))x$((height / 2))-0+0" -e "python3 mitm.py" &

wait