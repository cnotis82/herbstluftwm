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
    "$a" "Add Tag docs" herbstclient add '   '
    "$a" "Add Tag docker" herbstclient add '   '
    "$a" "Add Tag Youtube" herbstclient add '   '   
    "$a" "Add Tag VM" herbstclient add '   '
    "$a" "Add Tag Colibri" herbstclient add '   '
    "$a" "Delete Tag docs" herbstclient merge_tag '   '
    "$a" "Delete Tag Docker" herbstclient merge_tag '   '
    "$a" "Delete Tag Youtube" herbstclient merge_tag '   '  
    "$a" "Delete Tag VM" herbstclient merge_tag '   '  
    "$a" "Delete Tag Colibri" herbstclient merge_tag '   '
    "$a" "Delete Tag Scratchpad" herbstclient merge_tag "   "
    for tag in $(herbstclient complete 1 move) ; do
        "$a" "Move to tag $tag $i" herbstclient move_index "$i"
	i=$((i + 1))
    done
}

print_menu() {
    echo "$1"
}

title=$(herbstclient attr clients.focus.title)
title=${title//&/&amp;}
rofiflags=(
    -p "herbstclient:"
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

