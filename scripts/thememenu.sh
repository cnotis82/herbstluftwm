#!/usr/bin/env bash
set -e
#
# dependencies:
#
#   - rofi

# offer a window menu offering possible actions on that window like
# moving to a different tag or toggling its fullscreen state

action_list() {
    local a="$1"
    i=0
    "$a" "Enable Title in Tiling" herbstclient attr theme.tiling.title_height 15
    "$a" "Disable Title in Tiling" herbstclient attr theme.tiling.title_height 0
    "$a" "Enable Title in Floating" herbstclient attr theme.floating.title_height 15
    "$a" "Disable Title in Floating" herbstclient attr theme.floating.title_height 0
    "$a" "Enable Title in BSP" herbstclient set smart_window_surroundings 0
    "$a" "Disable Title in BSP" herbstclient set smart_window_surroundings 1
}

print_menu() {
    echo "$1"
}

title=$(herbstclient attr clients.focus.title)
title=${title//&/&amp;}
rofiflags=(
    -p "Themes"
    -mesg "<i>$title</i>"
    -columns 3
    -location 2
    -width 100
    -no-custom
)
result=$(action_list print_menu | rofi -i -dmenu -m -2 "${rofiflags[@]}")
[ $? -ne 0 ] && exit 0

exec_entry() {
    if [ "$1" = "$result" ] ; then
        shift
        "$@"
        exit 0
    fi
}

action_list exec_entry

