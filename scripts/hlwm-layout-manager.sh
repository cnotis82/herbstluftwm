#!/bin/bash
## HLWM Layout Manager ###########
# Version 0.2-2 by Scott Garrett #
# Wintervenom [(at)] gmail.com   #
##################################
dm="dmenu -i $DMENU_OPTIONS"
layouts="$HOME/.config/herbstluftwm/layouts"

file_menu () {
    ls "$layouts" | $dm -p "$*"
}

menu () {
    echo -e "${1//;/\n}" | $dm -p "$2"
}

hc () {
    hc_rs "$@"
}

mkdir -p "$layouts"
if [[ "$1" == 'load' ]]; then
    layout=$(file_menu 'Load layout:')
    [[ -z "$layout" ]] && exit
    if [[ -f "$layouts/$layout" ]]; then
        hc chain , emit_hook no_bsp \
                 , load "$(<"$layouts/$layout")" \
                 , emit_hook bsp
    else
        menu 'OK' 'No such layout.'
    fi
else
    layout=$(file_menu 'Save layout:')
    [[ -z "$layout" ]] && exit
    if [[ -f "$layouts/$layout" ]]; then
        action=$(menu "No;Yes" 'Overwrite?')
        [[ "$action" != 'Yes' ]] && exit
    fi
    hc dump > "$layouts/$layout"
fi

