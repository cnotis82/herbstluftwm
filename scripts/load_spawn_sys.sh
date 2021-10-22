#!/usr/bin/env bash

spawn_with_rules() {(
    # this rule also requires, that the client
    # sets the _NET_WM_PID property
    herbstclient rule pid=$BASHPID maxage=10 "${RULES[@]}"
    exec "$@"
    ) &
}

herbstclient chain , emit_hook no_bsp , add "  " , load "  " "(split horizontal:0.26:1 (clients grid:0) (split horizontal:0.66:0 (clients grid:0) (clients grid:0)))" , , emit_hook bsp

RULES=( tag="  " hook="  " index=0 )
spawn_with_rules arandr

RULES=( tag="  " hook="  " index=1 )
spawn_with_rules alacritty -e tmux a -t system

RULES=( tag="  " hook="  " floating=off pseudotile=off index=11 )
spawn_with_rules xfce4-power-manager-settings
