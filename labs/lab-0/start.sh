#!/bin/bash

width=$(tput cols)
height=$(tput lines)

xterm -geometry "$((width / 2))x$((height / 2))+0+0"
xterm -geometry "$((width / 2))x$((height / 2))+0+$((height / 2 + 1))"
xterm -geometry "$((width / 2))x$((height / 2))+$((width / 2 + 1))+$height"