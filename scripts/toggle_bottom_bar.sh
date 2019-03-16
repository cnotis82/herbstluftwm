#!/usr/bin/env bash
pid=$(cat /tmp/bottom-bar.pid)
polybar-msg -p $pid cmd toggle
exit 0
