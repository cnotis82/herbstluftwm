#!/usr/bin/env bash
pid=$(cat /tmp/bottom-bar.pid)
polybar-msg -p $pid cmd show

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
#
herbstclient pad $monitor " 20 " "0 " "20 " "0"
exit 0
