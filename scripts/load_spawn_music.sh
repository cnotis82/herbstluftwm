#!/usr/bin/env bash

spawn_with_rules() {(
    # this rule also requires, that the client
    # sets the _NET_WM_PID property
    herbstclient rule once pid=$BASHPID maxage=10 "${RULES[@]}"
    exec "$@"
    ) &
}

herbstclient chain , emit_hook no_bsp , add music , load music "(split vertical:0.8:0 (clients grid:0) (clients grid:0))" , emit_hook bsp

RULES=( tag=music hook=music index=0 )
spawn_with_rules alacritty -e tmux a -t home

RULES=( tag=music hook=music index=1 )
spawn_with_rules alacritty -e cava
