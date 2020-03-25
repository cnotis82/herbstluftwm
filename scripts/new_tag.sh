

#!/usr/bin/env bash
# new_tag.sh

# add keybind to autostart
# hc keybind <keybind> spawn path/to/this/script/new_tag.sh

# i put my mod variables in here:
#source ~/.config/herbstluftwm/vars.sh

hc() {
    herbstclient "$@"
}


tagname=$(rofi -dmenu -p "add_tag" -lines 0 | xargs)

hc chain , add $tagname , sprintf VAL "$Mod-%s" tags.count keybind VAL use $tagname