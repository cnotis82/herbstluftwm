#!/usr/bin/env bash

spawn_with_rules() {(
    # this rule also requires, that the client
    # sets the _NET_WM_PID property
    herbstclient rule pid=$BASHPID maxage=10 "${RULES[@]}"
    exec "$@"
    ) &
}

herbstclient chain , emit_hook no_bsp , add "'  " , load "'  " "(split horizontal:0.7767:0 (clients max:0) (clients horizontal:0))" , emit_hook bsp

RULES=( class=discord tag="'  " hook="'  " index=0 )
spawn_with_rules discord

RULES=( tag="'  " hook="'  " index=1 )
spawn_with_rules viber
