#!/usr/bin/env bash

# usage: start this script in anywhere your autostart (but *after* the
# emit_hook reload line)

# to switch to the last tag, call: herbstclient emit_hook goto_last_tag
# or bind it: herbstclient keybind Mod1-Escape emit_hook goto_last_tag
mode=1
transparent=1
tag=""
hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
hc --idle '(tag_changed|reload|quit_panel|urgent|tag_added|tag_removed|rule|goto_last_tag|fullscreen|floating|pseudotile|split_bottom|split_right|list_keys|version|layout_dump|print|tag_flags|bsp|no_bsp|max|trans|no_trans)' \
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
                notify-send -u critical "Herbstluftwm will be reloaded"
                polybar-msg cmd quit
                killall dunst
                killall compton
                
                exit
                ;;
            quit_panel)
                polybar-msg cmd quit
                #killall fluxgui
                killall packages.sh
                notify-send -u critical "Panels will be reloaded"
                ;;
            tag_added)
                notify-send -u low "Tag ${args[1]} added"
                ;;
            tag_removed)
                notify-send -u low "Tag ${args[1]} removed"
                ;;
            trans)
				transparent=1
                notify-send -u low "Transparent enabled"
				;;
			no_trans)
				transparent=0
                notify-send -u low "Transparent disabled"
				;;
            bsp)
				mode=1
                notify-send -u low "Binary split enabled"
				;;
			no_bsp)
				mode=0
                notify-send -u low "Binary split disabled"
				;;
            tag_flags)
                if [ $mode -eq 1 ]; then
                    hc chain : lock : and , compare tags.focus.curframe_wcount = 0 , close_and_remove : unlock
                    hc chain : lock : and , compare tags.focus.frame_count = 1 , ! silent get_attr tags.focus.my_unmaximized_layout , set_layout grid : unlock
                fi
                ;;
            rule|tag_flags)
				lasttag="$tag"
				tag=${args[1]}
                winid=${args[2]}
                focus=$(hc attr tags.focus.name)
                if [ $transparent -eq 1 ]; then
                transset-df -i "$winid"
               	fi
				if [ $mode -eq 1 ]; then
							if [ $tag == $focus ]; then
	                               hc chain : lock \
                                         : and , set_layout max , compare tags.by-name."$tag".curframe_wcount gt 1 \
                                            , ! silent get_attr tags.by-name."$tag".my_unmaximized_layout \
                                            , split explode \
                                            , cycle_frame \
                                        : unlock
	                        fi
            #                 if [ $tag == $focus ]; then
            #                     hc chain : lock : and , set_layout max \
            #                            , compare tags.focus.curframe_wcount gt 1 \
            #                            , ! silent get_attr tags.focus.my_unmaximized_layout \
            #                            , split explode  \
            #                            , cycle_frame \
									   # : unlock
            #                 fi
                	hc and , compare tags.focus.curframe_wcount = 0 , close_and_remove 
            	fi
                
                xdotool set_window --urgency 1 $winid
                ;;
            fullscreen)
                notify-send -u low "Fullscreen $tag"
                ;;
            floating)
                notify-send -u low "Floating $tag"
                ;;
            pseudotile)
                notify-send -u low "Pseudotile $tag"
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
            new_frame)
                ;;
        esac
    done
