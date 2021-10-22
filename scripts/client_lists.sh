#!/usr/bin/env bash
set -e
#
# dependencies:
#
#   - rofi

# offer a window menu offering possible actions on that window like
# moving to a different tag or toggling its fullscreen state

print_menu=(
    hc_rs list_clients --title

)

rofiflags=(
    -p "Search"
    -mesg "<i>Tag Windows</i>"
    -columns 3
    -location 0
    -width 100
    -no-custom
)
result=$("${print_menu[@]}" | rofi -i -lines 10 -padding 20 -width 50 -show drun -sidebar-mode -columns 3 -dmenu  "${rofiflags[@]}")
[ $? -ne 0 ] && exit 0

IFS=' ' # space is set as delimiter
read -ra RES <<< "$result"

hc_rs jumpto ${RES[0]}
