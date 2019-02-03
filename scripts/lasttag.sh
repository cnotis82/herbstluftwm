#!/usr/bin/env bash

# usage: start this script in anywhere your autostart (but *after* the
# emit_hook reload line)

# to switch to the last tag, call: herbstclient emit_hook goto_last_tag
# or bind it: herbstclient keybind Mod1-Escape emit_hook goto_last_tag

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
hc --idle '(tag_changed|reload|quit_panel|tag_added|tag_removed|goto_last_tag|fullscreen|floating|pseudotile|split_bottom|split_right|list_keys|version|layout_dump)' \
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
                killall redshiftgui.elf
                killall dunst
                notify-send -u critical "Herbstluftwm will be reloaded"
                exit
                ;;
            quit_panel)
                polybar-msg cmd quit
                killall packages.sh
                notify-send -u critical "Panels will be reloaded"
                ;;
            tag_added)
                notify-send -u low "Tag ${args[1]} added"
                ;;
            tag_removed)
                notify-send -u low "Tag ${args[1]} removed"
                ;;
            fullscreen)
                notify-send -u low "Fullscreen mode"
                ;;
            floating)
                notify-send -u low "Floating mode"
                ;;
            pseudotile)
                notify-send -u low "Pseudotile mode"
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
