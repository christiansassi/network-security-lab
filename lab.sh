#!/bin/bash

clear

options=("Lab 0" "Lab 1" "Lab 2" "Lab 3" "Ctr+C to exit")
width=25
cols=1

for ((i=0;i<${#options[@]};i++)); do 
    string="- ${options[$i]}"
    printf "%s" "$string"
    printf "%$(($width-${#string}))s" " "
    [[ $(((i+1)%$cols)) -eq 0 ]] && echo
done

while true; do

    echo
    read -p "Lab " opt

    case $opt in
        0)
            (cd ./labs/lab-0/ ; chmod +x start.sh ; ./start.sh)
            ;;

        1)
            (cd ./labs/lab-1/ ; chmod +x start.sh ; ./start.sh)
            sudo mn -c
            ;;

        2)
            (cd ./labs/lab-2/ ; chmod +x start.sh ; ./start.sh)
            sudo mn -c
            ;;

        3)
            ;;

        *) ;;
    esac
done

