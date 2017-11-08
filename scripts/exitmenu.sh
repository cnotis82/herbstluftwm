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
    "$a" "Suspend" herbstclient spawn gksu systemctl suspend
    "$a" "Reboot" herbstclient spawn gksu systemctl reboot
    "$a" "Poweroff" herbstclient spawn gksu systemctl poweroff
    }

print_menu() {
    echo "$1"
}

title=$(herbstclient attr clients.focus.title)
title=${title//&/&amp;}
rofiflags=(
    -p "herbstclient:"
    -mesg "Exit Menu"
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

