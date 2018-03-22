#!/usr/bin/env bash

# usage: start this script in anywhere your autostart (but *after* the
# emit_hook reload line)

# to switch to the last tag, call: herbstclient emit_hook goto_last_tag
# or bind it: herbstclient keybind Mod1-Escape emit_hook goto_last_tag

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
hc --idle '(tag_changed|goto_last_tag|reload|fullscreen|split_bottom|split_right|list_keys|version|layout_dump)' \
    | while read line ; do
        IFS=$'\t' read -ra args <<< "$line"
        case ${args[0]} in
            tag_changed)
                lasttag="$tag"
                tag=${args[1]}
                ;;
            goto_last_tag)
                [ "$lasttag" ] && hc use "$lasttag"
                ;;
            reload)
                exit
                ;;
            fullscreen)
                notify-send -u low "Fullscreen toggle"
                ;;
            split_bottom)
                notify-send -u low "Split Bottom 0.5"
                ;;
            split_right)
                notify-send -u low "Split Right 0.5"
                ;;
            list_keys)
                keys=$(herbstclient list_keybinds)
                notify-send -u low -t 20000 "${keys}"
                ;;
            version)
            ver=$(herbstclient -v | cowsay)
                notify-send -u low "${ver}"
                ;;
            layout_dump)
            layout=$(herbstclient layout)
                notify-send -u low "${layout}"
                ;;
                
        esac
    done
