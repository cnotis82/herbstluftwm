#!/usr/bin/env bash

spawn_with_rules() {(
    # this rule also requires, that the client
    # sets the _NET_WM_PID property
    herbstclient rule pid=$BASHPID maxage=10 "${RULES[@]}"
    exec "$@"
    ) &
}

herbstclient lock

herbstclient chain , emit_hook no_bsp , add "  " , use "  " , load "  " "(split horizontal:0.26:0 (split vertical:0.5:1 (clients grid:0) (clients grid:0)) (split horizontal:0.66:0 (split vertical:0.8:1 (clients grid:0) (clients grid:0)) (clients grid:0)))" , emit_hook bsp

RULES=( tag="  " hook="  " index=00 )
spawn_with_rules arandr

RULES=( instance=Gufw.py tag="  " hook="  " index=01 )
spawn_with_rules  sudo gufw & disown 

RULES=( tag="  " hook="  " index=100 )
spawn_with_rules alacritty -e tmux a -t system

RULES=( tag="  " hook="  " floating=off pseudotile=off index=110 )
spawn_with_rules xfce4-power-manager-settings

RULES=( tag="  " hook="  " index=101 )
spawn_with_rules alacritty

herbstclient unlock