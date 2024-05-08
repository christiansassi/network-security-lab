#!/bin/bash

# Customize the prompt to "Lab"
PS3="Lab "

# Define your menu options
options=("Lab 0" "Lab 1" "Lab 2" "Lab 3" "Quit")

# Prompt the user to select an option
select opt in "${options[@]}"; do
    case $REPLY in
        0)
            (cd ./labs/lab-0/ ; chmod +x start.sh ; ./start.sh)
            ;;

        1)
            ;;

        2)
            ;;

        3)
            ;;

        4)
            break
            ;;

        *) ;;
    esac
done
