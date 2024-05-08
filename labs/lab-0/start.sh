#!/bin/bash

dimensions=$(xdpyinfo | awk '/dimensions:/ {print $2}')
width=$(echo "$dimensions" | cut -d 'x' -f 1)
height=$(echo "$dimensions" | cut -d 'x' -f 2)

xterm -geometry "$((width / 2))x$((height / 2))+0+0" -e "python3 client.py" &
xterm -geometry "$((width / 2))x$((height / 2))+0-0" -e "python3 server.py" &
xterm -geometry "$((width / 2))x$((height / 2))-0+0" -e "python3 mitm.py" &

wait