#!/usr/bin/env bash
#
# This script will provide a menu for the contents of the ~/docs directory
# If you select a file, it will open in your favorite editor (or nano)
#
# You can run this script with this command
#
#    ./librasmart.sh
#
# To run this script, make sure it is executable
#
#    chmod +x ~/libresmart.sh
#
# To autostart, add the following to your ~/.bashrc
#
#    if [ `tty` == '/dev/tty1' ] && [ -f ~/libresmart.sh ]; then
#        . ~/libresmart.sh
#    fi
#
# Limitations:
# - There is no way to delete files through this interface.
#

docs=~/docs
editor=${EDITOR:=nano}
mkdir -p "$docs" && cd "$docs" || exit

PS3="
Enter a number or directory/file name (or CTRL + C to exit): "

location=.
while [ -d "$location" ]; do
    clear
    echo "Curent Directory is: ~/docs${location#.}"
    echo 
    dots=..
    if [ "$location" == "." ]; then dots=.; fi

    select option in $dots $(ls --file-type "$location"); do
        selection="$location/${option%/}"
        if [ "$option" == ""      ]; then
            if [ "$REPLY" == "" ]; then break; fi
            newname="$REPLY"
            selection="$location/${newname%/}"
            read -ep  "Should '$newname' be a File or Directory (f/d)? " filedir
            case ${filedir:0:1} in
                f|F ) touch    "$selection" ;;
                d|D ) mkdir -p "$selection" ;;
                *   ) echo "Unrecognized option, returning to menu..."; sleep 1; break ;;
            esac
        fi
        if [ "$option" == "$dots" ]; then location="$(dirname "$location")"; break; fi 
        if [ -d "$selection"      ]; then location="${selection}"; break; fi
        $editor "$selection"
        break
    done
done
