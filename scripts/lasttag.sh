#!/usr/bin/env bash

# usage: start this script in anywhere your autostart (but *after* the
# emit_hook reload line)

# to switch to the last tag, call: herbstclient emit_hook goto_last_tag
# or bind it: herbstclient keybind Mod1-Escape emit_hook goto_last_tag

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
hc --idle '(tag_changed|reload|quit_panel|urgent|tag_added|tag_removed|rule|goto_last_tag|fullscreen|floating|pseudotile|split_bottom|split_right|list_keys|version|layout_dump|print)' \
    | while read line ; do
        IFS=$'\t' read -ra args <<< "$line"
        case ${args[0]} in
            tag_changed)
                lasttag="$tag"
                tag=${args[1]}
                # sleep 1
                # status=( $(herbstclient tag_status) )
                # empty="."
                # #notify-send -u critical "$status $tag"
                # for i in ${!status[@]} ; do
                #     if [ "${status[$i]}" = "$empty" ]; then
                #         hc merge_tag " ${status[$(( $i + 1 ))]}  "
                #     fi
                # done
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
            tag_flags)
               
                ;;
            # urgent)
            #     notify-send -u critical "Urgent Window"
            #     ;;
            rule)
                
                #herbstclient add "${args[1]}"
                # status=( $(herbstclient tag_status) )
                # found=false
                # #notify-send -u critical "$status $tag"
                # for i in ${!status[@]} ; do
                #     if [ "${status[$i]}" = "${args[1]}" ]; then
                #         found=true
                #     fi
                # done
                
                # if [ "$found" = false ] ; then
                #     hc add "${args[1]}"
                # fi
                #hc add "${args[1]}"
                #sleep 1
                winid=${args[2]}
                xdotool set_window --urgency 1 $winid
                ;;
            fullscreen)
                notify-send -u low "Fullscreen ${args[1]}"
                ;;
            floating)
                notify-send -u low "Floating ${args[1]}"
                ;;
            pseudotile)
                notify-send -u low "Pseudotile ${args[1]}"
                ;;    
            split_bottom)
                notify-send -u low "Split Bottom 0.5"
                ;;
            split_right)
                notify-send -u low "Split Right 0.5"
                ;;
            print)
                notify-send -u low "Screenshot saved in Pictures"
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
