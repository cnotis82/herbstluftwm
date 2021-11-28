#!/usr/bin/env bash
set -e
#
# dependencies:
#
#   - rofi

# offer a window menu offering possible actions on that window like
# moving to a different tag or toggling its fullscreen state

print_menu=(
    hc_rs foreach C clients.
        #substitute TAG tags.focus.name
        sprintf WINIDATTR '%c.winid' C substitute WINID WINIDATTR
        sprintf TITLEATTR '%c.title' C substitute TITLE TITLEATTR
        sprintf MINATTR '%c.minimized' C substitute MIN MINATTR
        sprintf CTAGATTR '%c.tag' C substitute TAG CTAGATTR
        or : and , compare MINATTR = false
           : sprintf AGEATTR '%c.my_minimized_age' C substitute AGEATT AGEATTR and . compare MINATTR = true . echo TAG TITLE AGEATTR WINID

)

rofiflags=(
    -p "Search"
    -mesg "<i>Minimized Windows</i>"
    -columns 3
    -location 0
    -width 100
    -no-custom
)
result=$("${print_menu[@]}" | rofi -i -lines 10 -padding 20 -width 50 -show drun -sidebar-mode -columns 3 -dmenu  "${rofiflags[@]}")
[ $? -ne 0 ] && exit 0

IFS=' ' # space is set as delimiter
read -ra RES <<< "$result"

hc and : jumpto ${RES[-1]} : remove_attr ${RES[-2]}
