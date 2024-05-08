#!/bin/bash

xterm -geometry "80x20+0+0" -e "python3 client.py" &
xterm -geometry "80x20+0-0" -e "python3 server.py" &
xterm -geometry "80x20-0+0" -e "python3 mitm.py" &

wait