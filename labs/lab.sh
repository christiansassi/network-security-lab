#!/bin/bash

options=("Lab 0: Simulation" "Lab 1: Access Point (AP) testing" "Lab 2: Client (STA) testing" "Lab 3: Krack Attack" "Ctr+C to exit")
width=25
cols=1

while true; do

    clear

    cat ./assets/vm/splashscreen.txt

    for ((i=0;i<${#options[@]};i++)); do 
        string="- ${options[$i]}"
        printf "%s" "$string"
        printf "%$(($width-${#string}))s" " "
        [[ $(((i+1)%$cols)) -eq 0 ]] && echo
    done

    echo
    read -p "Lab " opt

    case $opt in
        0)
            (cd ./labs/lab-0/ ; chmod +x start.sh ; ./start.sh)
            ;;

        1)
            (cd ./labs/lab-1/ ; chmod +x start.sh ; ./start.sh)
            ;;

        2)
            (cd ./labs/lab-2/ ; chmod +x start.sh ; ./start.sh)
            ;;

        3)
            ;;

        *) ;;
    esac

done
