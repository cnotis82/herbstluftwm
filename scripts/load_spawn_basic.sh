#!/usr/bin/env bash

spawn_with_rules() {(
    # this rule also requires, that the client
    # sets the _NET_WM_PID property
    herbstclient rule pid=$BASHPID maxage=10 "${RULES[@]}"
    exec "$@"
    ) &
}

herbstclient chain , emit_hook no_bsp , add music , load music "(split vertical:0.8:0 (clients grid:0) (clients grid:0))" , emit_hook bsp

RULES=( tag=music hook=music index=0 once)
spawn_with_rules alacritty -e tmux a -t home

RULES=( tag=music hook=music index=1 once)
spawn_with_rules alacritty -e cava

herbstclient chain , emit_hook no_bsp , add "  " , load "  " "(split horizontal:0.26:1 (clients grid:0) (split horizontal:0.66:0 (split vertical:0.8:1 (clients grid:0) (clients grid:0)) (clients grid:0)))
" , , emit_hook bsp

RULES=( tag="  " hook="  " index=0 )
spawn_with_rules arandr

RULES=( tag="  " hook="  " index=100 once)
spawn_with_rules alacritty -e tmux a -t system

RULES=( tag="  " hook="  " floating=off pseudotile=off index=110 )
spawn_with_rules xfce4-power-manager-settings

RULES=( tag="  " hook="  " index=101 once)
spawn_with_rules alacritty

herbstclient chain , emit_hook no_bsp , add "'  " , load "'  " "(split horizontal:0.7767:0 (clients max:0) (clients horizontal:0))" , emit_hook bsp

RULES=( class=discord tag="'  " hook="'  " index=0)
spawn_with_rules discord

RULES=( tag="'  " hook="'  " index=1 )
spawn_with_rules viber

RULES=( tag="  " hook="  " once)
spawn_with_rules alacritty -e tmux a -t chat

RULES=( tag="  " hook="  " once)
spawn_with_rules alacritty -e tmux a -t scratchpad

herbstclient spawn pcmanfm

herbstclient spawn firefox
