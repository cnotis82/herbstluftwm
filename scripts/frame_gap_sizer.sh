#!/usr/bin/env bash


[ $1 = "+x" ] && herbstclient set frame_gap $(( $(herbstclient attr settings.frame_gap) + 2 ))
[ $1 = "-x" ] && herbstclient set frame_gap $(( $(herbstclient attr settings.frame_gap) - 2 ))
