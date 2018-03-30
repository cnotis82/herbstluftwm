#!/usr/bin/env bash
set -e
#
# dependencies:
#
#   - rofi

# offer a window menu offering possible actions on that window like
# moving to a different tag or toggling its fullscreen state

action_list() {
    pid=$(cat /tmp/bottom-bar.pid)
    local a="$1"
    i=0
    "$a" "Quit" polybar-msg cmd quit
    "$a" "Restart" polybar-msg cmd restart
    "$a" "Show" polybar-msg cmd show
    "$a" "Hide" polybar-msg cmd hide
    "$a" "Toggle" polybar-msg cmd toggle
    "$a" "Toggle bottom bar" polybar-msg -p $pid cmd toggle
    
}

print_menu() {
    echo "$1"
}

rofiflags=(
    -p "Polybar:"
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

