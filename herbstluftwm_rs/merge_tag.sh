

#!/usr/bin/env bash
# merge_tag.sh

# add keybind to autostart
# hc keybind <keybind> spawn path/to/this/script/merge_tag.sh

# i put my mod variables in here:
#source ~/.config/herbstluftwm/vars.sh

hc() {
    hc_rs "$@"
}

tagname=$(rofi -dmenu -p "merge_tag" -lines 0 | xargs)


hc merge_tag $tagname
