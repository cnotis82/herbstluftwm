#!/usr/bin/env bash

# usage: start this script in anywhere your autostart (but *after* the
# emit_hook reload line)

# to switch to the last tag, call: herbstclient emit_hook goto_last_tag
# or bind it: herbstclient keybind Mod1-Escape emit_hook goto_last_tag
mode=0
transparent=1
stick=0
tag=""
clientid=""
sticktag=""
hc() { "${herbstclient_command[@]:-hc_rs}" "$@" ;}
hc_rs --idle '(tag_changed|reload|quit_panel|urgent|tag_added|tag_removed|rule|fullscreen|floating|minimized|pseudotile|split_bottom|split_right|list_keys|version|layout_dump|print|tag_flags|bsp|no_bsp|max|trans|no_trans|sticky|no_sticky)' \
    | while read line ; do
        IFS=$'\t' read -ra args <<< "$line"
        case ${args[0]} in
            tag_changed)
                lasttag="$tag"
                tag=${args[1]}

                if [ $stick -eq 1 ]; then
                    hc lock
                    hc foreach C clients. \
                        sprintf WINIDATTR '%c.winid' C substitute WINID WINIDATTR \
                        sprintf CSTICKYATTR '%c.my_sticky' C \
                        and . compare CSTICKYATTR = 1 \
                            . bring WINID
                    hc unlock
                fi
                ;;
            reload)
                notify-send -u critical "Herbstluftwm will be reloaded"
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
            sticky)
                stick=1
                sticktag=$(hc attr tags.focus.name)

                hc try silent new_attr int clients.$(hc attr clients.focus.winid).my_sticky 1;
                hc try silent new_attr string clients.$(hc attr clients.focus.winid).my_sticky_tag "$sticktag";
                notify-send -u low "Client marked as sticky" "$clientid"
                ;;
            no_sticky)
                stick=0
                FOCUSID=$(hc attr clients.focus.winid)
                hc silent attr clients.${FOCUSID}.my_sticky "0";

                hc foreach C clients. \
                    substitute FOCUSTAG tags.focus.name \
                    sprintf CSTICKYATTR '%c.my_sticky' C \
                    sprintf CSTICKYTAGATTR '%c.my_sticky_tag' C substitute TAG CSTICKYTAGATTR \
                    sprintf CTAGATTR '%c.tag' C \
                    and . compare CTAGATTR = FOCUSTAG \
                        . compare CSTICKYATTR = 0 \
                        . move TAG

                hc chain . try remove_attr clients.${FOCUSID}.my_sticky \
                         . try remove_attr clients.${FOCUSID}.my_sticky_tag \
                         . try remove_attr clients.${FOCUSID}.my_sticky_layout

                notify-send -u low "Client unmarked as sticky"
                ;;
            no_sticky_no_move)
                stick=0
                FOCUSID=$(hc attr clients.focus.winid)
                hc silent attr clients.${FOCUSID}.my_sticky "0";

                notify-send -u low "Client unmarked as sticky"
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
                mode=0
                hc try remove_attr tags.focus.my_bsp_mode
                notify-send -u low "Binary split enabled"
                ;;
            no_bsp)
                mode=1
                hc try silent new_attr int tags.focus.my_bsp_mode 1
                notify-send -u low "Binary split disabled"
                ;;
            tag_flags)
                if [ $mode -eq 0 ]; then
                    hc chain : lock : and , compare tags.focus.curframe_wcount = 0 , close_and_remove : unlock
                    hc chain : lock : and , compare tags.focus.frame_count = 1 , ! silent get_attr tags.focus.my_unmaximized_layout , set_layout grid : unlock
                fi
                hc chain : and , compare tags.focus.curframe_wcount gt 0 , set_attr settings.smart_window_surroundings 1 : and , compare tags.focus.curframe_wcount gt 1 , set_attr settings.smart_window_surroundings 0
                ;;
            rule|tag_flags)
                lasttag="$tag"
                tag=${args[1]}
                winid=${args[2]}
                focus=$(hc attr tags.focus.name)
                bsp_mode=$(hc attr tags.by-name."$tag".my_bsp_mode)


                if [ $transparent -eq 1 ]; then
                    transset-df -i "$winid" 0.85
                fi

                #if [ $bsp_mode -eq 1 ]; then
                #    mode=1
                #fi

                #if [ $mode -eq 0 ]; then
                #    if [ $tag == $focus ]; then
                #          hc chain : lock \
                #                   : and , set_layout max , compare tags.by-name."$tag".curframe_wcount gt 1 \
                #                        , ! silent get_attr tags.by-name."$tag".my_unmaximized_layout \
                #                        , split explode \
                #                   : unlock
                #    fi
                #    hc and , compare tags.focus.curframe_wcount = 0 , close_and_remove
                #fi

                xdotool set_window --urgency 1 $winid
                #mode=0
                ;;
            fullscreen)
                #notify-send -u low "Fullscreen $tag"
                ;;
            floating)
                notify-send -u low "Floating $tag"
                ;;
            minimized)
                notify-send -u low "Minimized $tag"
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
            ver=$(herbstclient version | cowsay)
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
